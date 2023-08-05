//
//  SidebarViewController.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/5.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import UIKit

enum SidebarMenuOption: CaseIterable {
    case airplane
    case car
    case bus
    case tram
}

extension SidebarMenuOption {
    
    var name: String {
        switch self {
        case .airplane:
            return "airplane"
        case .car:
            return "car"
        case .bus:
            return "bus"
        case .tram:
            return "tram"
        }
    }
    
    var iconName: String {
        switch self {
        case .airplane:
            return "airplane"
        case .car:
            return "car"
        case .bus:
            return "bus"
        case .tram:
            return "tram"
        }
    }
}

class SidebarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SideBar"
        view.backgroundColor = .white
    }

}
