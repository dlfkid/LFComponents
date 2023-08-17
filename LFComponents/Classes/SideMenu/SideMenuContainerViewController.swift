//
//  SideMenuContainerViewController.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/8/12.
//

import UIKit

public protocol SideMenuControllable: UIViewController {
    var sideMenuContainer: SideMenuContainerViewController? {get set}
}

public enum SideMenuStatus {
    case extended
    case folded
}

public class SideMenuContainerViewController: UIViewController {
    
    private var menuStatus: SideMenuStatus = .folded
    
    var sideMenuActionHandler: ((_ controller: SideMenuContainerViewController, _ menuStatus: SideMenuStatus) -> Bool)? = { controller, menuStatus in
        
        guard let primarayViewController = controller.primiaryViewController else {
            return false
        }
        
        switch menuStatus {
        case .folded:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                primarayViewController.navigationController?.view.frame.origin.x = primarayViewController.view.frame.width - 100
            }
        case .extended:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                primarayViewController.navigationController?.view.frame.origin.x = 0
            }
        }
        return true
    }
    
    /// decide which view controller is shown when the container is loaded
    public var primaryViewControllerIndex: Int = 0
    
    /// ViewControllers to serve as the sideMenu
    public var sideMenuViewController: SideMenuControllable?
    
    /// ViewControllers to show
    public var contentViewControllers: [SideMenuControllable]?
    
    var primiaryViewController: SideMenuControllable? {
        guard let contentViewControllers: [SideMenuControllable] = contentViewControllers, primaryViewControllerIndex < contentViewControllers.count else {
            return nil
        }
        let primarayViewController = contentViewControllers[primaryViewControllerIndex]
        return primarayViewController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addSideMenuVC()
        addPrimarayContainerVC()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    private func addSideMenuVC() {
        guard let sideMenuVC = sideMenuViewController else {
            return
        }
        sideMenuVC.sideMenuContainer = self
        addChildViewController(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParentViewController: self)
    }
    
    private func addPrimarayContainerVC() {
        guard let primarayViewController = primiaryViewController else {
            return
        }
        primarayViewController.sideMenuContainer = self
        let navigationController = UINavigationController(rootViewController: primarayViewController)
        addChildViewController(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: self)
    }
}

extension SideMenuContainerViewController {
    public func sidemenuSwitchState() {
        guard let sideMenuActionHandler = sideMenuActionHandler else {
            return
        }
        let result = sideMenuActionHandler(self, menuStatus)
        if result {
            switch menuStatus {
            case .extended:
                menuStatus = .folded
            case .folded:
                menuStatus = .extended
            }
        }
    }
    
    public func segueToPrimaryViewController(index: Int) {
        guard let primarayViewController = primiaryViewController, let nav = primarayViewController.navigationController else {
            return
        }
        guard index != primaryViewControllerIndex else {
            nav.popToRootViewController(animated: false)
            return
        }
        nav.popToRootViewController(animated: false)
        guard let nextController = contentViewControllers?[index] else {
            return
        }
        nextController.sideMenuContainer = self
        nav.pushViewController(nextController, animated: false)
    }
}
