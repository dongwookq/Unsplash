//
//  SearchResult.swift
//  unsplash
//
//  Created by Dong-Wook Han on 2020/06/27.
//  Copyright © 2020 kakaopay. All rights reserved.
//

import Foundation

struct SearchResult : Codable {
    let total : Int?
    let total_pages : Int?
    let results : [Results]?

    enum CodingKeys: String, CodingKey {

        case total = "total"
        case total_pages = "total_pages"
        case results = "results"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try values.decodeIfPresent(Int.self, forKey: .total)
        total_pages = try values.decodeIfPresent(Int.self, forKey: .total_pages)
        results = try values.decodeIfPresent([Results].self, forKey: .results)
    }

}
