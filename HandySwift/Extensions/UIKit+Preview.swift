//
//  UIKit+Preview.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/18.
//

import Foundation
import SwiftUI
import UIKit

/// 预览 UIViewController
struct UIViewControllerPreviewWrapper<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T

    init(_ viewControllerBuilder: @escaping () -> T) {
        viewController = viewControllerBuilder()
    }

    func makeUIViewController(context _: Context) -> T {
        viewController
    }

    func updateUIViewController(_: T, context _: Context) {}
}

/// 预览 UIView
struct UIViewPreviewWrapper<T: UIView>: UIViewRepresentable {

    let view: T
    init(_ viewBuilder: @escaping () -> T) {
        view = viewBuilder()
    }

    func makeUIView(context _: Context) -> UIView {
        view
    }

    func updateUIView(_: UIView, context _: Context) {}
}
