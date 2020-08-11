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

    var pixels: [[UIColor]] {
        guard let cgImage = base.cgImage else {
            return []
        }
        let size = cgImage.width * cgImage.height
        var result = [[UIColor]]()
        var queue  = [UIColor]()
        result.reserveCapacity(size)
        generator { (color) in
            queue.append(color)
            if queue.count == cgImage.width {
                result.append(queue)
                queue.removeAll()
            }
        }
        return result
    }

    func generator(callback: (UIColor) -> Void) {
        guard let cgImage = base.cgImage,
              let data = cgImage.dataProvider?.data,
              let bytes = CFDataGetBytePtr(data) else {
            fatalError("Couldn't access image data")
        }
        assert(cgImage.colorSpace?.model == .rgb)

        let bytesPerPixel = cgImage.bitsPerPixel / cgImage.bitsPerComponent
        for y in 0 ..< cgImage.height {
            for x in 0 ..< cgImage.width {
                let offset = (y * cgImage.bytesPerRow) + (x * bytesPerPixel)
                let components = (r: CGFloat(bytes[offset]), g: CGFloat(bytes[offset + 1]), b: CGFloat(bytes[offset + 2]))
                callback(UIColor(red: components.r / 255, green: components.g / 255, blue: components.b / 255, alpha: 1))
            }
        }
    }
}
