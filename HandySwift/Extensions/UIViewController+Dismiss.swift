//
//  UIViewController+Dismiss.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/9/3.
//

import Foundation
import UIKit

extension UIViewController {
    func dismissAllPresented(completion: (() -> Void)? = nil) {
        if let presentedVC = presentedViewController {
            presentedVC.dismissAllPresented {
                presentedVC.dismiss(animated: true, completion: completion)
            }
        } else {
            completion?()
        }
    }
}
