//
//  ResponseModels.swift
//  Restaurant Project
//
//  Created by Megan Schmoyer on 12/18/23.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}
struct OrderResponse: Codable {
    let prepTime: Int

    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}

