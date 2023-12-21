//
//  Representative.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/5/23.
//

import Foundation

struct Representative: Codable {
    let repName: String
    let repParty: String
    let repLink: String

    enum CodingKeys: String, CodingKey {
        case repName = "name"
        case repParty = "party"
        case repLink = "link"
    }
init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    repName = try container.decode(String.self, forKey: CodingKeys.repName)
    repParty = try container.decode(String.self, forKey: CodingKeys.repParty)
    repLink = try container.decode(String.self, forKey: CodingKeys.repLink)

}
    }
struct SearchResponse: Codable {
    let results: [Representative]
}
