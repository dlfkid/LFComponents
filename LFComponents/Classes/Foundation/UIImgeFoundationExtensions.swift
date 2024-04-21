//
//  UIImgeFoundationExtensions.swift
//  LFComponents
//
//  Created by LeonDeng on 2023/9/9.
//

import Foundation

extension UIImage: LFCWrapperable { }

public extension LFCWrapper where T: UIImage {
    /// Returns true if the image has an alpha layer
    var hasAlpha: Bool {
        guard let alpha = value.cgImage?.alphaInfo else { return false }
        return alpha == CGImageAlphaInfo.first ||
                alpha == CGImageAlphaInfo.last ||
                alpha == CGImageAlphaInfo.premultipliedFirst ||
                alpha == CGImageAlphaInfo.premultipliedLast
    }
    
    func resized(newSize: CGSize) -> UIImage? {
        if let cgImage = value.cgImage {
            let originImage = UIImage(cgImage: cgImage)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
            originImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        } else {
            return nil
        }
    }
    
    static func image(from color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContext(.init(width: 1, height: 1))
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(.init(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// 根据rect裁剪图片
    /// - Parameter rect: 裁剪框
    /// - Returns: 裁剪后的图片
    func crop(to rect: CGRect) -> UIImage? {
        let imageSize = self.value.size

        // Check if the cropping rectangle is within the image bounds
        guard rect.origin.x >= 0 && rect.origin.y >= 0 &&
              rect.origin.x + rect.size.width <= imageSize.width &&
              rect.origin.y + rect.size.height <= imageSize.height else {
            return nil
        }

        // Perform the cropping
        guard let cgImage = self.value.cgImage?.cropping(to: rect) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: self.value.scale, orientation: self.value.imageOrientation)
    }
    
    /// 图片染色
    /// - Parameters:
    ///   - tintColor: 主题色
    ///   - resize: 染色后大小
    /// - Returns: 染色后图片
    func imageWithTintColor(tintColor: UIColor, resize: CGSize? = nil) -> UIImage {
        guard let cgImage = value.cgImage else { return value }
        let rect = CGRect(x: 0, y: 0, width: value.size.width, height: value.size.height)
        let alpha = cgImage.alphaInfo
        let opaque = alpha == CGImageAlphaInfo.none || alpha == CGImageAlphaInfo.noneSkipLast || alpha == CGImageAlphaInfo.noneSkipFirst
        UIGraphicsBeginImageContextWithOptions(value.size, opaque, value.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: value.size.height);
        context?.scaleBy(x: 1.0, y: -1.0);
        context?.setBlendMode(.normal)
        context?.clip(to: rect, mask: cgImage)
        context?.setFillColor(tintColor.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? value
    }
    
    /// 旋转图片
    /// - Parameter degrees: 角度
    /// - Parameter tintColor: 主题色, 旋转图片会失去原来的染色, 需要重新染色
    /// - Returns: 旋转后的图片
    func rotateImage(byDegrees degrees: CGFloat, tintColor: UIColor?) -> UIImage? {
        let radians = degrees * .pi / 180.0

        // Set up the transformation matrix
        var transform = CGAffineTransform.identity
        transform = transform.translatedBy(x: value.size.width / 2, y: value.size.height / 2)
        transform = transform.rotated(by: radians)
        transform = transform.translatedBy(x: -value.size.width / 2, y: -value.size.height / 2)

        // Apply the transformation to the image
        if let cgImage = value.cgImage,
           let colorSpace = cgImage.colorSpace,
           let context = CGContext(data: nil,
                                   width: Int(value.size.width),
                                   height: Int(value.size.height),
                                   bitsPerComponent: cgImage.bitsPerComponent,
                                   bytesPerRow: 0,
                                   space: colorSpace,
                                   bitmapInfo: cgImage.bitmapInfo.rawValue) {

            context.concatenate(transform)

            // Draw the image into the context
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: value.size.width, height: value.size.height))

            // Create a new UIImage from the context
            guard let rotatedImage = context.makeImage() else {
                return nil
            }
            
            guard let tintColor = tintColor else {
                return UIImage(cgImage: rotatedImage)
            }
            
            // 渲染颜色
            if #available(iOS 13.0, *) {
                let image = UIImage(cgImage: rotatedImage)
                return image.withTintColor(tintColor, renderingMode: .alwaysOriginal)
            } else {
                let image = UIImage(cgImage: rotatedImage)
                return image.lfc.imageWithTintColor(tintColor: tintColor)
            }
        }

        // Return nil if the rotation fails
        return nil
    }
    
    /// 输入边距来根据长宽中的长边等比例扩大或缩小图片
    /// - Parameter maxEdge: 边距
    /// - Returns: 缩放后的图片
    func rescaledByLongSide(_ maxEdge: CGFloat) -> UIImage? {
        guard maxEdge > 0 else { return nil }
        
        var resizedImage: UIImage? = value
        if max(value.size.width, value.size.height) > maxEdge {
            let scale = maxEdge / max(value.size.width, value.size.height)
            let resizedRect = CGRect.init(x: 0, y: 0, width: value.size.width * scale, height: value.size.height * scale)
            UIGraphicsBeginImageContext(resizedRect.size)
            value.draw(in: resizedRect)
            resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        return resizedImage
    }
}
