//
//  Dog.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/5/23.
//

import Foundation

struct Dog: Decodable {
    let imageString: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case message
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        imageString = try container.decode(String.self, forKey: .message)
        status = try container.decode(String.self, forKey: .status)
    }
}
extension Dog {
    var imageURL: URL {
        URL(string: imageString)!
    }
}
