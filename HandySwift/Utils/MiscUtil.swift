//
//  MiscUtil.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/31.
//

import Foundation

class MiscUtil {
    class func image(fromImage image: UIImage, scaleRatio: CGFloat, backgroundColor: UIColor) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)

        let newImage = renderer.image { context in
            let ctx = context.cgContext
            ctx.setFillColor(backgroundColor.cgColor)
            ctx.fill(CGRect(origin: .zero, size: image.size))
            let newSize = CGSize(width: image.size.width * scaleRatio, height: image.size.height * scaleRatio)
            let rect = CGRect(x: (image.size.width - newSize.width) / 2,
                              y: (image.size.height - newSize.height) / 2,
                              width: newSize.width,
                              height: newSize.height)
            image.draw(in: rect)
        }

        return newImage
    }
}
