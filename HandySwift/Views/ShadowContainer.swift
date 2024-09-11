//
//  ShadowContainer.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/3.
//

import Foundation
import SnapKit
import UIKit

class ShadowContainer: UIView {

    var contentView: UIView
    var roundedPath: UIBezierPath?

    var cornerRadius: Double = 0
    var absoluteCornerRadius: Double = 0
    var roundCorners: UIRectCorner = .allCorners

    var borderWidth: Double = 0
    var borderColor: UIColor?

    var isCapsule: Bool = false
    var useAbsoluteCornerRadius: Bool = false

    private var borderLayer: CAShapeLayer = .init()

    init(subview: UIView,
         cornerRadius: Double = 0.2,
         shadowRadius: Double = 5.0,
         shadowOpacity: Double = 0.5) {
        contentView = subview
        super.init(frame: .zero)
        commonInit(
            subview: subview,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowOpacity: shadowOpacity
        )
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit(
        subview _: UIView,
        cornerRadius _cornerRaidus: Double,
        shadowRadius: Double,
        shadowOpacity: Double
    ) {
        backgroundColor = .clear
        roundCorners = .allCorners

        // Add Content View
        addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Set Corner Related Variables
        isCapsule = false
        useAbsoluteCornerRadius = false
        cornerRadius = min(0.5, max(0, _cornerRaidus))

        // Set Shadow Related Variables
        layer.shadowRadius = CGFloat(shadowRadius)
        layer.shadowOpacity = Float(shadowOpacity)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)

        borderLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let pathRadius: CGFloat = if !useAbsoluteCornerRadius {
            if isCapsule {
                min(bounds.width, bounds.height) / 2
            } else {
                min(bounds.width, bounds.height) * CGFloat(cornerRadius)
            }
        } else {
            CGFloat(absoluteCornerRadius)
        }

        let newRoundedPath = UIBezierPath(roundedRect: bounds,
                                          byRoundingCorners: roundCorners,
                                          cornerRadii: CGSize(width: pathRadius, height: pathRadius))

        let maskLayer = CAShapeLayer()
        maskLayer.path = newRoundedPath.cgPath

        layer.shadowPath = newRoundedPath.cgPath
        contentView.layer.mask = maskLayer

        if let borderColor {
            borderLayer.path = newRoundedPath.cgPath
            borderLayer.strokeColor = borderColor.cgColor
            borderLayer.lineWidth = CGFloat(borderWidth)
            borderLayer.frame = bounds
        }
        roundedPath = newRoundedPath
    }

    func setAbsoluteCornerRadius(_ absoluteRadius: Double, shouldUseAbsolute: Bool) {
        useAbsoluteCornerRadius = shouldUseAbsolute
        absoluteCornerRadius = absoluteRadius
        setNeedsLayout()
    }

    func resetContentView(_ newContentView: UIView) {
        contentView.removeFromSuperview()
        contentView = newContentView
        addSubview(contentView)
        contentView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setShadow(radius: Double, opacity: Double) {
        layer.shadowRadius = CGFloat(radius)
        layer.shadowOpacity = Float(opacity)
        setNeedsLayout()
    }

    func setShadowOffset(_ shadowOffset: CGSize) {
        layer.shadowOffset = shadowOffset
        setNeedsLayout()
    }

    func setShadowColor(_ shadowColor: UIColor) {
        layer.shadowColor = shadowColor.cgColor
        setNeedsLayout()
    }
}
