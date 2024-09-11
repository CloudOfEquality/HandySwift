//
//  CircularGaugeView.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/9/4.
//

import Foundation
import UIKit

class CircularGaugeView: UIView {

    private var backgroundLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()

    var lineWidth: CGFloat = 10 {
        didSet {
            configureLayers()
        }
    }

    var progress: CGFloat = 0 {
        didSet {
            progress = min(max(progress, 0), 1)
            configureLayers()
        }
    }

    var gaugeColor: UIColor = .label {
        didSet {
            configureLayers()
        }
    }

    var backgroundColorLayer: UIColor = UIConst.Color.Translucence.moderate {
        didSet {
            configureLayers()
        }
    }

    // 自定义初始化方法，带默认参数
    init(frame: CGRect,
         progress: CGFloat = 0,
         lineWidth: CGFloat = 10,
         gaugeColor: UIColor = .label,
         backgroundColor: UIColor = UIConst.Color.Translucence.moderate) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.gaugeColor = gaugeColor
        backgroundColorLayer = backgroundColor
        super.init(frame: frame)
        configureLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayers()
    }

    private func configureLayers() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - lineWidth / 2
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -(.pi / 2),
            endAngle: 2 * .pi - (.pi / 2),
            clockwise: true
        )

        // 设置背景环形路径
        backgroundLayer.path = circularPath.cgPath
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = backgroundColorLayer.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round

        // 设置进度环形路径
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = gaugeColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = progress

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(progressLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureLayers()
    }
}
