//
//  MovieController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/1/22.
//

import Foundation
import CoreData

class MovieController {
    static let shared = MovieController()
    
    private let apiController = MovieAPIController()
    private var viewContext = PersistenceController.shared.viewContext
    
    func fetchMovies(with searchTerm: String) async throws -> [APIMovie] {
           return try await apiController.fetchMovies(with: searchTerm)
       }
       
       // Fetch favorite movies from Core Data
    func fetchFavoriteMovies(with searchText: String) async throws -> [Movie] {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()

        if !searchText.isEmpty {
            // If searchText is not empty, filter the results using an NSPredicate
            fetchRequest.predicate = NSPredicate(format: "title CONTAINS[c] %@ AND isFavorite == true", searchText)
        } else {
            // Fetch only favorite movies
            fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        }

        do {
            let favoriteMovies = try await viewContext.fetch(fetchRequest)
            return favoriteMovies
        } catch {
            throw error
        }
    }
    func convertToMovie(_ apiMovie: APIMovie) -> Movie {
        let movie = Movie(context: PersistenceController.shared.viewContext)
        movie.title = apiMovie.title
        movie.year = apiMovie.year
        movie.imdbID = apiMovie.imdbID
        movie.posterURLString = apiMovie.posterURL?.absoluteString
        return movie
    }
    
}
extension MovieController {
    func saveFavoriteMovie(_ movie: APIMovie) {
        let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)

        do {
            let existingMovie = try viewContext.fetch(fetchRequest).first

            if let existingMovie = existingMovie {
                // Update the existing movie to mark it as a favorite
                existingMovie.isFavorite = true
                try viewContext.save()
                print("Updated \(movie.title) as a favorite in Core Data!")
            } else {
                // Create a new entry if the movie is not in Core Data
                let favoriteMovie = Movie(context: viewContext)
                favoriteMovie.title = movie.title
                favoriteMovie.year = movie.year
                favoriteMovie.imdbID = movie.imdbID
                favoriteMovie.posterURLString = movie.posterURL?.absoluteString
                favoriteMovie.isFavorite = true

                try viewContext.save()
                print("Saved \(movie.title) as a favorite in Core Data!")
            }
        } catch {
            print("Error saving \(movie.title) to Core Data: \(error.localizedDescription)")
        }
    }
    func unfavoriteMovie(_ movie: Movie) {
        movie.isFavorite = false

        do {
            try viewContext.save()
            print("Unfavorited \(movie.title ?? "") from Core Data!")
        } catch {
            print("Error unfavoriting \(movie.title ?? "") from Core Data: \(error.localizedDescription)")
        }
    }
        func isFavorite(_ movie: APIMovie) -> Bool {
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imdbID == %@ AND isFavorite == true", movie.imdbID)
            
            do {
                let existingMovie = try viewContext.fetch(fetchRequest).first
                return existingMovie != nil
            } catch {
                print("Error checking if movie is a favorite: \(error.localizedDescription)")
                return false
            }
        }
        
        func removeFavoriteMovie(_ movie: APIMovie) {
            let fetchRequest: NSFetchRequest<Movie> = Movie.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "imdbID == %@", movie.imdbID)
            
            do {
                let existingMovie = try viewContext.fetch(fetchRequest).first
                
                if let existingMovie = existingMovie {
                    viewContext.delete(existingMovie)
                    try viewContext.save()
                    print("Unfavorited \(movie.title) from Core Data!")
                }
            } catch {
                print("Error unfavoriting \(movie.title) from Core Data: \(error.localizedDescription)")
            }
        }
    }

