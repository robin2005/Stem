// MIT License
//
// Copyright (c) 2020 linhey
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

// MARK: - 初始化
public extension UIImage {
    /// 获取指定颜色的图片
    ///
    /// - Parameters:
    ///   - color: UIColor
    ///   - size: 图片大小
    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        
        guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else {
            self.init()
            return
        }
        self.init(cgImage: cgImage)
    }
}

// MARK: - UIImage
public extension Stem where Base: UIImage {
    /// 返回一张没有被渲染图片
    var original: UIImage { return base.withRenderingMode(.alwaysOriginal) }
    /// 返回一张可被渲染图片
    var template: UIImage { return base.withRenderingMode(.alwaysTemplate) }
}

public extension Stem where Base: UIImage {
    
    /// 修改单色系图片颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: 新图
    func setTint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(base.size, false, 0)
        defer { UIGraphicsEndImageContext() }
        color.setFill()
        let bounds = CGRect(x: 0, y: 0, width: base.size.width, height: base.size.height)
        UIRectFill(bounds)
        base.draw(in: bounds, blendMode: .overlay, alpha: 1)
        base.draw(in: bounds, blendMode: .destinationIn, alpha: 1)
        return UIGraphicsGetImageFromCurrentImageContext() ?? base
    }
    
    /// 修改单色系图片颜色
    ///
    /// - Parameter color: 颜色
    /// - Returns: 新图
    func tint(_ color: UIColor, blendMode: CGBlendMode) -> UIImage {
        let drawRect = CGRect(x: 0.0, y: 0.0, width: base.size.width, height: base.size.height)
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        let context = UIGraphicsGetCurrentContext()
        context!.clip(to: drawRect, mask: base.cgImage!)
        color.setFill()
        UIRectFill(drawRect)
        base.draw(in: drawRect, blendMode: blendMode, alpha: 1.0)
        let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return tintedImage!
    }

}


public extension Stem where Base: UIImage {

    @available(iOS 12.0, *)
    var colors: [UIColor: Int] {
        var result = [UIColor: Int]()
        generator { (color) in
            if result[color] == nil {
                result[color] = 1
            } else {
                result[color] = result[color]! + 1
            }
        }
        return result
    }

    @available(iOS 12.0, *)
    var pixels: [UIColor] {
        guard let cgImage = base.cgImage else {
            return []
        }
        let size = cgImage.width * cgImage.height
        var result = [UIColor]()
        result.reserveCapacity(size)
        generator { (color) in
            result.append(color)
        }
        return result
    }

    @available(iOS 12.0, *)
    func generator(callback: (UIColor) -> Void) {
        guard let cgImage = base.cgImage else {
            return
        }
        assert(cgImage.bitsPerPixel == 32, "only support 32 bit images")
        assert(cgImage.bitsPerComponent == 8,  "only support 8 bit per channel")
        guard let imageData = cgImage.dataProvider?.data as Data? else {
            return
        }
        let size = cgImage.width * cgImage.height
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: size)
        _ = imageData.copyBytes(to: buffer)
        for pixel in buffer {
            var r : UInt32 = 0
            var g : UInt32 = 0
            var b : UInt32 = 0
            if cgImage.byteOrderInfo == .orderDefault || cgImage.byteOrderInfo == .order32Big {
                r = pixel & 255
                g = (pixel >> 8) & 255
                b = (pixel >> 16) & 255
            } else if cgImage.byteOrderInfo == .order32Little {
                r = (pixel >> 16) & 255
                g = (pixel >> 8) & 255
                b = pixel & 255
            }
            let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
            callback(color)
        }
    }

}
