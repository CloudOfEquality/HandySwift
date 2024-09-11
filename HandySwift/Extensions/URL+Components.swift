//
//  URL+Components.swift
//  WetestCloudgame
//
//  Created by xiutongmu on 2024/8/2.
//

import Foundation

extension URL {

    func withPath(_ path: String) -> Self {
        if #available(iOS 16, *) {
            self.appending(path: path)
        } else {
            appendingPathComponent(path)
        }
    }

    func withQuery(_ param: [String: Any]) -> Self {
        guard !param.isEmpty else {
            return self
        }

        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        var queryItems = components?.queryItems ?? []
        for (key, value) in param {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        components?.queryItems = queryItems
        return components?.url ?? self
    }
}
