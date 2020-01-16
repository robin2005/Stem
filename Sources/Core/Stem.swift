/// MIT License
///
/// Copyright (c) 2020 linhey
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.

/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.

import Foundation

public class Stem<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol StemCompatible {
    associatedtype StemCompatibleType
    var st: StemCompatibleType { get }
}

public extension StemCompatible {
    var st: Stem<Self> { return Stem(self) }
    static var st: Stem<Self>.Type { return Stem<Self>.self }
}

extension NSObject: StemCompatible { }

public struct StemValue<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol StemValueCompatible {
    associatedtype StemValueCompatible
    var st: StemValueCompatible { get }
}

public extension StemValueCompatible {
    var st: StemValue<Self> { return StemValue(self) }
    static var st: StemValue<Self>.Type { return StemValue<Self>.self }
}
