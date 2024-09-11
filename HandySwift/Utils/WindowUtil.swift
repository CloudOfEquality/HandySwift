//
//  WindowUtil.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/3.
//

import Foundation
import UIKit

class WindowUtil {

    class func deviceHasNotch(withWindow: UIWindow? = nil) -> Bool {
        var hasNotch = false
        if let window = withWindow ?? keyWindow() {
            let safeAreaInsets = window.safeAreaInsets
            logVerbose("Get window safe area: \(safeAreaInsets)")
            hasNotch = safeAreaInsets.top > 0 || safeAreaInsets.bottom > 0 || safeAreaInsets.left > 0 || safeAreaInsets
                .right > 0
        }
        return hasNotch
    }

    class func keyWindow() -> UIWindow? {
        UIApplication.shared.windows.filter(\.isKeyWindow).first
    }

    class func findView(ofType className: String, in view: UIView) -> UIView? {
        if view.isKind(of: NSClassFromString(className)!) {
            return view
        }
        for subview in view.subviews {
            if let foundView = findView(ofType: className, in: subview) {
                return foundView
            }
        }
        return nil
    }
}
