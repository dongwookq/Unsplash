//
//  URL+Extensions.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/26.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

extension URL {
    func appending(queryItems: [URLQueryItem]) -> URL {
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return self
        }

        var queryDictionary = [String: String]()
        if let queryItems = components.queryItems {
            for item in queryItems {
                queryDictionary[item.name] = item.value
            }
        }

        for item in queryItems {
            queryDictionary[item.name] = item.value
        }

        var newComponents = components
        newComponents.queryItems = queryDictionary.map({ URLQueryItem(name: $0.key, value: $0.value) })

        return newComponents.url ?? self
    }
}
