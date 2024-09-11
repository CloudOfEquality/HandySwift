//
//  UIViewController+Alert.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/5.
//

import Foundation
import UIKit

extension UIViewController {

    var topViewController: UIViewController {
        var topVC = self
        while let presentedVC = topVC.presentedViewController {
            topVC = presentedVC
        }
        return topVC
    }

    // MARK: - No Button Alert

    func showAlert(message: String,
                   duration: CGFloat,
                   presentCompletion: (() -> Void)? = nil,
                   dismissCompletion: (() -> Void)? = nil,
                   presentedBy presenter: UIViewController? = nil) {
        let presenter = presenter ?? topViewController
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        presenter.present(alertController, animated: true, completion: presentCompletion)
        DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(duration)) {
            alertController.dismiss(animated: true, completion: dismissCompletion)
        }
    }

    // MARK: - Single Button Alert

    func showAlert(title: String?,
                   message: String?,
                   buttonTitle: String? = StringConst.Alert.confirm,
                   buttonConfig: [String: Any]? = nil,
                   buttonCompletion: ((UIAlertAction) -> Void)?,
                   presentedBy presenter: UIViewController? = nil) {
        let presenter = presenter ?? topViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: buttonTitle, style: .cancel) { action in
            buttonCompletion?(action)
        }
        if let config = buttonConfig {
            for (key, value) in config {
                confirmAction.setValue(value, forKey: key)
            }
        }
        alert.addAction(confirmAction)
        presenter.present(alert, animated: true, completion: nil)
    }

    // MARK: - Double Button Alert

    func showAlert(title: String?,
                   message: String?,
                   confirmTitle: String? = StringConst.Alert.confirm,
                   confirmActionConfig: [String: Any]? = nil,
                   confirmCompletion: ((UIAlertAction) -> Void)?,
                   cancelTitle: String? = StringConst.Alert.cancel,
                   cancelActionConfig: [String: Any]? = nil,
                   cancelCompletion: ((UIAlertAction) -> Void)?,
                   additionalActions: [UIAlertAction]? = nil,
                   atIndex index: Int = 0,
                   presentedBy presenter: UIViewController? = nil,
                   presentCompletion: (() -> Void)? = nil) {
        let presenter = presenter ?? topViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { action in
            confirmCompletion?(action)
        }
        if let config = confirmActionConfig {
            for (key, value) in config {
                confirmAction.setValue(value, forKey: key)
            }
        }

        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { action in
            cancelCompletion?(action)
        }
        if let config = cancelActionConfig {
            for (key, value) in config {
                cancelAction.setValue(value, forKey: key)
            }
        }

        var actions = [confirmAction, cancelAction]

        if let additionalActions, !additionalActions.isEmpty {
            let insertIndex = min(max(index, 0), actions.count)
            actions.insert(contentsOf: additionalActions, at: insertIndex)
        }

        actions.forEach { alert.addAction($0) }

        presenter.present(alert, animated: true, completion: presentCompletion)
    }
}
