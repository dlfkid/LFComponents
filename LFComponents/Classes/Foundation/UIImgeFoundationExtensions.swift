//
//  UIImgeFoundationExtensions.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/9/9.
//

import Foundation

extension UIImage {
    func resizeImage(toSize size: CGSize) -> UIImage? {
        // Create a graphics context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        // Draw the original image into the context
        self.draw(in: CGRect(origin: .zero, size: size))
        
        // Get the resized image from the context
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the graphics context
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
