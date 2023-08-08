//
//  SidemenuOption.swift
//  LFComponents_Example
//
//  Created by LeonDeng on 2023/8/8.
//  Copyright © 2023 CocoaPods. All rights reserved.
//

import Foundation

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
