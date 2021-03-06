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

private enum AssociatedKey {

    static let setNavigationBarHiddenWhenAppearKey = UnsafeRawPointer(bitPattern: "stem.viewController.setNavigationBarHiddenWhenAppearKey".hashValue)!
    static let isHideBackButtonTextKey = UnsafeRawPointer(bitPattern: "stem.UINavigationBarAppearance.isHideBackButtonText".hashValue)!

}

private extension UIViewController {

    static let viewController_swizzing: Void = {
        RunTime.exchange(selector: #selector(UIViewController.viewWillAppear(_:)),
                         by: #selector(UIViewController.stem_viewController_viewWillAppear(_:)),
                         class: UIViewController.self)

        RunTime.exchange(selector: #selector(UIViewController.viewWillDisappear(_:)),
                         by: #selector(UIViewController.stem_viewController_viewWillDisappear(_:)),
                         class: UIViewController.self)
    }()

    @objc
    func stem_viewController_viewWillAppear(_ animated: Bool) {
        stem_viewController_viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(navigationItem.st.isHiddenWhenViewWillAppear, animated: animated)
    }

    @objc
    func stem_viewController_viewWillDisappear(_ animated: Bool) {
        stem_viewController_viewWillDisappear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now()) {[weak self] in
            guard let self = self,
                let vc = self.navigationController?.topViewController,
                self.navigationItem.st.isHiddenWhenViewWillAppear == false else { return }
            self.navigationController?.setNavigationBarHidden(vc.navigationItem.st.isHiddenWhenViewWillAppear, animated: false)
        }
    }

}

fileprivate
extension UINavigationItem {
    static var isHideBackButtonText: Bool = false
}

public extension Stem where Base: UINavigationItem {

    var isHiddenWhenViewWillAppear: Bool {
        get { getAssociated(for: AssociatedKey.setNavigationBarHiddenWhenAppearKey) ?? false }
        set {
            UIViewController.viewController_swizzing
            setAssociated(value: newValue, for: AssociatedKey.setNavigationBarHiddenWhenAppearKey)
        }
    }

    static var isHideBackButtonText: Bool {
        set {
            UINavigationController.navigationController_swizzing
            UINavigationItem.isHideBackButtonText = newValue
        }
        get { return UINavigationItem.isHideBackButtonText }
    }

}

fileprivate
extension UINavigationController {
    
    static let navigationController_swizzing: Void = {
        RunTime.exchange(selector: #selector(UINavigationController.pushViewController(_:animated:)),
                         by: #selector(UINavigationController.stem_navigationController_pushViewController(_:animated:)),
                         class: UINavigationController.self)
    }()

    @objc
    func stem_navigationController_pushViewController(_ viewController: UIViewController, animated: Bool) {
        if UINavigationItem.st.isHideBackButtonText {
            let backBarButtton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            viewController.navigationItem.backBarButtonItem = backBarButtton
        }
        stem_navigationController_pushViewController(viewController, animated: animated)
    }

}
