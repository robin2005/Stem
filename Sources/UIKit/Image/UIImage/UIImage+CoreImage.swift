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

public extension UIImage {

    /// 生成二维码
    convenience init?(qrCode: String, correctionLevel: CIFilter.Generator.QRCode.CorrectionLevel = .m) {
        let data = qrCode.data(using: .utf8)
        let filter = CIFilter.Generator.QRCode()
        filter.message = data
        filter.level = correctionLevel
        let transform = CGAffineTransform(scaleX: UIScreen.main.scale, y: UIScreen.main.scale)
        guard let output = filter.outputImage?.transformed(by: transform) else { return nil }
        self.init(ciImage: output)
    }

}

public extension Stem where Base: UIImage {

    /// 高斯模糊
    ///
    /// - Parameter value: 0 ~ 100, 0为不模糊
    func blur(value: Double) -> UIImage? {
        let filter = CIFilter.Blur.GaussianBlur()
        filter.image = CIImage(image: base)
        filter.radius = NSNumber(value: min(100, max(0, value)))
        guard let output = filter.outputImage else { return nil }
        let context = CIContext()
        guard let cgImage = context.createCGImage(output, from: output.extent) else { return nil }
        let image = UIImage(cgImage: cgImage)
        return image
    }

}
