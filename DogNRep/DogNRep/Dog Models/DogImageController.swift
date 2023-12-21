//
//  DogImageController.swift
//  DogNRep
//
//  Created by Megan Schmoyer on 12/5/23.
//

import Foundation

enum DogError: Error {
    case badResponse
}
class DogImageController {
    let baseURL = URL(string: "https://dog.ceo/api/breeds/image/random")!
    
    //fetch dog
    func fetchDog() async throws -> Dog {
        let (data, response) = try await URLSession.shared.data(from: baseURL)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DogError.badResponse
        }

        let jsonDecoder = JSONDecoder()
        let dog = try jsonDecoder.decode(Dog.self, from: data)
        
        return dog
    }
    //fetch image
    func fetchImage(for url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw DogError.badResponse
        }
        return data
    }
}
