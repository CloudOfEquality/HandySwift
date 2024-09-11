//
//  RoundIconButton.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/4.
//

import Foundation
import SnapKit
import UIKit

enum ImageConstrainedByEnum {
    case both, height, width
}

class RoundIconButton: UIView {

    var container: ShadowContainer
    var button: UIButton
    var imageView: UIImageView
    var constrainedBy: ImageConstrainedByEnum = .both {
        didSet {
            // Call imageScale didSet
            let _imageScale = imageScale
            imageScale = _imageScale
        }
    }

    var imageScale: Double = 0.5 {
        didSet {
            if imageView.superview != nil {
                imageView.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    switch constrainedBy {
                    case .both:
                        make.height.width.equalToSuperview().multipliedBy(imageScale)
                    case .height:
                        make.height.equalToSuperview().multipliedBy(imageScale)
                    case .width:
                        make.width.equalToSuperview().multipliedBy(imageScale)
                    }

                }
            }
        }
    }

    var touchScale: Double = 0.925
    var animateTouch: Bool = true

    var isCapsule: Bool {
        get { container.isCapsule }
        set { container.isCapsule = newValue }
    }

    var menu: UIMenu? {
        didSet {
            if #available(iOS 14.0, *) {
                button.menu = menu
            }
        }
    }

    override var backgroundColor: UIColor? {
        get { button.backgroundColor }
        set { button.backgroundColor = newValue }
    }

    init(image: UIImage?) {
        button = UIButton()
        imageView = UIImageView(image: image)
        container = ShadowContainer(subview: button, cornerRadius: 0, shadowRadius: 10, shadowOpacity: 0.5)

        super.init(frame: .zero)

        button.backgroundColor = .systemBlue

        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 1, height: 1)

        container.isCapsule = true

        setupViews()
        setupButtonAnimations()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(container)
        addSubview(imageView)

        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalToSuperview().multipliedBy(imageScale)
        }
    }

    func setContainerCornerRadius(_ cornerRadius: Double) {
        container.cornerRadius = cornerRadius
    }

    func setImageShadow(radius: Double, opacity: Double) {
        imageView.layer.shadowRadius = CGFloat(radius)
        imageView.layer.shadowOpacity = Float(opacity)
    }

    func setButtonShadow(radius: Double, opacity: Double) {
        container.setShadow(radius: radius, opacity: opacity)
    }

    func resetImage(_ image: UIImage?) {
        imageView.image = image
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) {
        button.addTarget(target, action: action, for: controlEvents)
    }

    func removeTarget(_ target: Any?, action: Selector?, for controlEvents: UIControl.Event) {
        button.removeTarget(target, action: action, for: controlEvents)
    }

    func sendActions(for controlEvents: UIControl.Event) {
        button.sendActions(for: controlEvents)
    }

    private func setupButtonAnimations() {
        addTarget(self, action: #selector(scaleDown), for: .touchDown)
        addTarget(self, action: #selector(scaleUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    @objc private func scaleDown() {
        guard animateTouch else { return }
        UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: self.touchScale, y: self.touchScale)
        }, completion: nil)
    }

    @objc private func scaleUp() {
        guard animateTouch else { return }
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView == container || hitView == imageView {
            return button
        }
        return hitView
    }
}
