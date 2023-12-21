//
//  RepresentativeController.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/5/23.
//

import Foundation

class RepresentativeController {
    enum RepresentativeError: Error, LocalizedError {
        case representativeNotFound
    }
    func fetchRepresentative(matching query: [String: String]) async throws -> [Representative] {
        var urlComponents = URLComponents(string: "https://whoismyrepresentative.com/getall_mems.php?zip=31023&output=json")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw RepresentativeError.representativeNotFound
        }
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        
        return searchResponse.results
        
    }
}
