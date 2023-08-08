//
//  SidebarViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

enum SideMenuState {
    case open
    case closed
}

protocol SideMenuControllable: SidebarViewController {
    func sidemenuSwitchState()
}

protocol SideMenuOptionHandlable: SidebarViewController {
    func didSelectedItem(item: SidebarMenuOption)
}

class SidebarViewController: UIViewController {
    
    private var menuState: SideMenuState = .closed
    
    let sidemenu = SidemenuViewController()
    
    let homeContent = AirplaneViewController()
    
    private var homeNavigationController: UINavigationController? {
        return homeContent.navigationController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SideBar"
        view.backgroundColor = .white
        addChildVCs()
    }
    
    private func addChildVCs() {
        sidemenu.delegate = self
        addChildViewController(sidemenu)
        view.addSubview(sidemenu.view)
        sidemenu.didMove(toParentViewController: self)
        
        homeContent.delegate = self
        let navigationController = UINavigationController(rootViewController: homeContent)
        addChildViewController(navigationController)
        view.addSubview(navigationController.view)
        navigationController.didMove(toParentViewController: self)
    }
}

extension SidebarViewController: SideMenuControllable {
    func sidemenuSwitchState() {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.homeContent.navigationController?.view.frame.origin.x = self.homeContent.view.frame.width - 100
                self.menuState = .open
            }
        case .open:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.homeContent.navigationController?.view.frame.origin.x = 0
                self.menuState = .closed
            }
        }
    }
}

extension SidebarViewController: SideMenuOptionHandlable {
    func didSelectedItem(item: SidebarMenuOption) {
        sidemenuSwitchState()
        guard let nav = homeNavigationController else {
            return
        }
        nav.popToRootViewController(animated: false)
        switch item {
        case .airplane:
            break
        case .car:
            let controller = CarViewController()
            controller.delegate = self
            nav.pushViewController(controller, animated: false)
            break
        case .bus:
            let controller = BusViewController()
            controller.delegate = self
            nav.pushViewController(controller, animated: false)
            break
        case .tram:
            let controller = TramViewController()
            controller.delegate = self
            nav.pushViewController(controller, animated: false)
            break
        }
    }
}
