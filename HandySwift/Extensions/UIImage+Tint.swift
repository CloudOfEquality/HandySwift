//
//  UIImage+Tint.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/19.
//

import Foundation

/**
 To make the code prettier and more swifty,
 use``UIImage.tint(_:)``and``UIImage.tint(_:render:)``
 to replace ``UIImage.withTintColor(_:renderingMode:)``
 */

extension UIImage {
    @available(iOS 13.0, *)
    func tint(_ color: UIColor) -> UIImage {
        withTintColor(color)
    }

    @available(iOS 13.0, *)
    func tint(_ color: UIColor, render: UIImage.RenderingMode) -> UIImage {
        withTintColor(color, renderingMode: render)
    }
}

/**
 To make SF symbol UIImage generation perttier and more swifty
 */

extension UIImage {

    /**
     ``class UIImage.system(_:tint:weight:palette:more:)``

     - Parameters:
        - weight  Symbol weight
        - tint    Apply tint color
        - palette Switch the rendering mode to palette and apply multiple colors
        - more    Add any configurations you want. Note that the sequence could matter

     - Note
        - tint    **ALWAYS OVERRIDES** the palette param!
        - palette **WILL NOT TAKE EFFECT** on system older than iOS 15.0
        - If neither of tint and palette is given, image color defaults to UIColor.label
     */
    class func system(_ system: String,
                      weight: UIImage.SymbolWeight? = nil,
                      tint: UIColor? = nil,
                      palette: [UIColor]? = nil,
                      scale: UIImage.SymbolScale? = nil,
                      more: [UIImage.SymbolConfiguration]? = nil) -> UIImage? {
        // Getting UIImage from SF symbol name
        guard var image = UIImage(systemName: system) else {
            return nil
        }

        // Colleting all configs to be applied
        var configs = [UIImage.SymbolConfiguration]()
        if let weight {
            configs.append(UIImage.SymbolConfiguration(weight: weight))
        }
        if let palette, #available(iOS 15.0, *) {
            configs.append(UIImage.SymbolConfiguration(paletteColors: palette))
        }
        if let scale {
            configs.append(UIImage.SymbolConfiguration(scale: scale))
        }
        if let more {
            configs += more
        }

        // Applying combined config to image
        guard var combine = configs.first else {
            return image
        }
        configs.dropFirst().forEach { combine = combine.applying($0) }
        image =  image.applyingSymbolConfiguration(combine) ?? image

        // Applying tint
        if let tint {
            image = image.tint(tint, render: .alwaysOriginal)
        } else if palette == nil {
            image = image.tint(.label, render: .alwaysOriginal)
        }

        return image
    }
}
