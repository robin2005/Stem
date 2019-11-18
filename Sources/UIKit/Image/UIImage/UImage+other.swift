//
//  Stem
//
//  github: https://github.com/linhay/Stem
//  Copyright (c) 2019 linhay - https://github.com/linhay
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE

import UIKit

public extension UIImage {
    
    convenience init?(named: String, in bundle: Bundle) {
        let manager = FileManager.default
        guard let res = manager.enumerator(atPath: bundle.bundlePath)?
            .allObjects
            .compactMap({ (item) -> String? in
                return item as? String
            }).first(where: { (item) -> Bool in
                return item.components(separatedBy: "/").last?.components(separatedBy: ".").first == .some(named)
            }),
            let bundle = Bundle(path: bundle.bundlePath + res)
            else { return nil }
        self.init(named: named, in: bundle, compatibleWith: nil)
    }
    
}

public extension UIImage {

  public enum OverlayAlignment {
        /// 居中
        case center(x: CGFloat, y: CGFloat)
        /// 左上
        case zero(x: CGFloat, y: CGFloat)
    }

}

public extension Stem where Base: UIImage {

    /// 叠加图片
    ///
    /// - Parameters:
    ///   - image: 覆盖至上方图片
    ///   - offset: 覆盖图片偏移 正值向下向右
    /// - Returns: 新图
    func overlay(image: UIImage, alignment: UIImage.OverlayAlignment = .center(x: 0, y: 0)) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, UIScreen.main.scale)
        defer { UIGraphicsEndImageContext() }
        base.draw(in: CGRect(origin: .zero, size: base.size))
        switch alignment {
        case .center(x: let x, y: let y):
            let origin = CGPoint(x: (base.size.width - image.size.width) * 0.5 + x,
                                 y: (base.size.height - image.size.height) * 0.5 + y)
            image.draw(in: CGRect(origin: origin, size: image.size))
        case .zero(x: let x, y: let y):
            let origin = CGPoint(x: x, y: y)
            image.draw(in: CGRect(origin: origin, size: image.size))
        }
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }

}


public extension Stem where Base: UIImage {

    func toAttributedString(bounds: CGRect) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = base
        attachment.bounds = bounds
        return NSAttributedString(attachment: attachment)
    }

    func toMutableAttributedString(bounds: CGRect) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = base
        attachment.bounds = bounds
        return NSMutableAttributedString(attachment: attachment)
    }

}
