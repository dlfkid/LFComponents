//
//  UIColorFoundationExtensions.swift
//  LFComponents
//
//  Created by Ravendeng on 2024/4/21.
//

import Foundation

extension UIColor: LFCWrapperable {}

/// init color with Hex
public extension LFCWrapper where T: UIColor {
    
    /// note: 如果最高位为 00，会被忽略掉，透明度不生效，默认为 1.0
    static func hex(_ color: Int64) -> UIColor {
        if color > 0xffffff {
            return UIColor(red: CGFloat((color)>>16 & 0xff)/255.0, green: CGFloat((color) >> 8 & 0xff)/255.0, blue: CGFloat((color) & 0xff)/255.0, alpha: CGFloat((color)>>24 & 0xff)/255.0)
        } else {
            return UIColor(red: CGFloat((color)>>16 & 0xff)/255.0, green: CGFloat((color) >> 8 & 0xff)/255.0, blue: CGFloat((color) & 0xff)/255.0, alpha: 1.0)
        }
    }
    
    static func hex(color: Int64, alpha: CGFloat) -> UIColor {
        return UIColor(red: CGFloat((color)>>16 & 0xff)/255.0, green: CGFloat((color) >> 8 & 0xff)/255.0, blue: CGFloat((color) & 0xff)/255.0, alpha: alpha)
    }
    
    static func hex(_ string: String) -> UIColor {
        var str = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.count == 0 {
            return UIColor()
        }
        str = str.replacingOccurrences(of: Substring("#"), with: Substring(""))
        str = str.replacingOccurrences(of: Substring("0x"), with: Substring(""))
        if str.count > 8 { return UIColor() }
        var alpha: CGFloat = 1.0
        if str.count == 8 {
            let alphaStrIndex = str.index(str.startIndex, offsetBy: 2)
            let alphaStr = String(str[..<alphaStrIndex])
            alpha = CGFloat((Int64(alphaStr, radix:16) ?? 0) & 0xff) / 255.0
            str = String(str[alphaStrIndex...])
        }
        let color: Int64 = Int64(str, radix:16) ?? 0
        return hex(color: color, alpha: alpha)
    }
    
    func image(size: CGSize) -> UIImage? {
        let view = UIView.init(frame: CGRect(origin: CGPoint.zero, size: size))
        view.backgroundColor = value
        UIGraphicsBeginImageContext(size)
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/// color to image
public extension LFCWrapper where T: UIColor {
    /// color to image
    /// - Parameter size: image size
    /// - Returns: image
    func toImage(with size: CGSize) -> UIImage? {
        return UIImage.lfc.image(from: value)
    }
}
