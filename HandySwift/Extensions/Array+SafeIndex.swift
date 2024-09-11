//
//  Array+SafeIndex.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/7/20.
//

import Foundation

// Safe array access extension

extension Array {
    subscript(safe index: some BinaryInteger) -> Element? {
        indices.contains(Int(index)) ? self[Int(index)] : nil
    }
}
