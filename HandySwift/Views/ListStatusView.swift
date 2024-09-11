//
//  ListStatusView.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/2.
//

import Foundation
import SnapKit
import UIKit

struct ListStatus {
    enum ListStatusEnum: Int {
        case success
        case empty
        case denied
        case error
        case failed
    }

    var val: ListStatusEnum
    var message: String?
}

class ListStatusView: UIView {

    static let defaultStatusIconSize = 50.0
    class func defaultErrorMessage(_ errorMessage: String?) -> String {
        "\(StringConst.Alert.responseError)\n(\(errorMessage ?? "Unknown Error"))"
    }

    class func defaultFailedMessage(_ errorMessage: String?) -> String {
        "\(StringConst.Alert.requestFailed)\n(\(errorMessage ?? "Unknown Failure"))"
    }

    var icon: UIImageView!
    var message: UILabel!

    init(image: UIImage?, message: String?, iconSize: Double = defaultStatusIconSize) {
        super.init(frame: .zero)
        setupViews(withImage: image, info: message, iconSize: iconSize)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews(withImage image: UIImage?, info: String?, iconSize: Double) {
        backgroundColor = .clear

        icon = UIImageView(image: image)
        icon.contentMode = .scaleAspectFit

        message = UILabel()
        message.text = info
        message.font = UIFont.monospacedSystemFont(ofSize: UIConst.FontSize.secondary, weight: .semibold)
        message.numberOfLines = 0
        message.textAlignment = .center
        message.lineBreakMode = .byWordWrapping

        addSubview(icon)
        addSubview(message)

        icon.snp.makeConstraints { make in
            make.top.centerX.equalTo(self)
            make.width.height.equalTo(iconSize)
        }

        message.snp.makeConstraints { make in
            make.bottom.left.right.equalTo(self)
            make.top.equalTo(icon.snp.bottom).offset(UIConst.Margin.outer)
        }
    }

    // MARK: - Instance Makers

    class func defaultEmptyView(message: String?,
                                tintColor: UIColor = .secondaryLabel,
                                iconSize: Double = defaultStatusIconSize) -> ListStatusView {
        let image = UIImage(named: "LargeIconNull")?.tint(tintColor)
        let emptyView = ListStatusView(image: image, message: message, iconSize: iconSize)
        emptyView.message.textColor = tintColor
        emptyView.alpha = 0
        return emptyView
    }

    class func defaultDeniedView(message: String?,
                                 tintColor: UIColor = .systemOrange,
                                 iconSize: Double = defaultStatusIconSize) -> ListStatusView {
        let image = UIImage(named: "LargeIconWarn")?.tint(tintColor)
        let denidedView = ListStatusView(image: image, message: message, iconSize: iconSize)
        denidedView.message.textColor = tintColor
        denidedView.alpha = 0
        return denidedView
    }

    class func defaultErrorView(message: String?,
                                tintColor: UIColor = .systemRed,
                                iconSize: Double = defaultStatusIconSize) -> ListStatusView {
        let image = UIImage(named: "LargeIconError")?.tint(tintColor)
        let errorView = ListStatusView(
            image: image,
            message: defaultErrorMessage(message),
            iconSize: iconSize
        )
        errorView.message.textColor = tintColor
        errorView.alpha = 0
        return errorView
    }

    class func defaultFailedView(message: String?,
                                 tintColor: UIColor = .systemRed,
                                 iconSize: Double = defaultStatusIconSize) -> ListStatusView {
        let image = UIImage(named: "LargeIconFailure")?.tint(tintColor)
        let failedView = ListStatusView(
            image: image,
            message: defaultFailedMessage(message),
            iconSize: iconSize
        )
        failedView.message.textColor = tintColor
        failedView.alpha = 0
        return failedView
    }
}
