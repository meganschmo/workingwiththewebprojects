//
//  FavoritesViewController.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 11/3/22.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var backgroundView: UIView!
    
    private let movieController = MovieController.shared
    private var datasource: UITableViewDiffableDataSource<Int, Movie>!
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search favorites"
        sc.searchBar.delegate = self
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        navigationItem.searchController = searchController
        fetchFavorites()
    }
    
    private func setUpTableView() {
        tableView.backgroundView = backgroundView
        setUpDataSource()
        tableView.register(UINib(nibName: MovieTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.reuseIdentifier)
    }
    
    private func setUpDataSource() {
         datasource = UITableViewDiffableDataSource<Int, Movie>(tableView: tableView) { tableView, indexPath, movie in
             let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.reuseIdentifier) as! MovieTableViewCell
             cell.update(with: movie) {
                 self.removeFavorite(movie)
             }
             return cell
         }
     }
    func updateUIAfterRemovingFavorite(_ movie: Movie) {
         // Use optional chaining for datasource
         let currentSnapshot = datasource?.snapshot()
         
         // Check if currentSnapshot is not nil before proceeding
         guard var snapshot = currentSnapshot else {
             // Handle the case where datasource is not initialized
             return
         }
         
         // Find the index of the movie in the snapshot
         if let index = snapshot.indexOfItem(movie) {
             snapshot.deleteItems([movie])
             
             // Apply the updated snapshot to the data source
             datasource?.apply(snapshot, animatingDifferences: true)
         }
         
         fetchFavorites()  // Fetch favorites after removing one
     }

 
    func updateUIAfterAddingFavorite(_ movie: Movie) {
        // Use optional chaining for datasource
        let currentSnapshot = datasource?.snapshot()
        
        // Check if currentSnapshot is not nil before proceeding
        guard var snapshot = currentSnapshot else {
            // Handle the case where datasource is not initialized
            return
        }

        snapshot.appendItems([movie])
        datasource?.apply(snapshot, animatingDifferences: true)
        fetchFavorites()
    }
    func applyNewSnapshot(from movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Movie>()
        snapshot.appendSections([0])
        snapshot.appendItems(movies)
        datasource?.apply(snapshot, animatingDifferences: true)
        tableView.backgroundView = movies.isEmpty ? backgroundView : nil

    }
    
    func fetchFavorites() {
        Task {
            let searchText = searchController.searchBar.text ?? ""
            let favorites = try? await movieController.fetchFavoriteMovies(with: searchText)
            print("Fetched \(favorites?.count ?? 0) favorites.")
            applyNewSnapshot(from: favorites ?? [])
        }
        DispatchQueue.main.async {
                self.fetchFavorites()
                self.tableView.reloadData()
            }
    }
    
    func removeFavorite(_ movie: Movie) {
        movieController.unfavoriteMovie(movie)
        fetchFavorites()  // Fetch favorites after removing one
    }
}
    // MARK: - UISearchResult Updating and UISearchControllerDelegate
    
    extension FavoritesViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
        func updateSearchResults(for searchController: UISearchController) {
            fetchFavorites()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            fetchFavorites()
        }
    }

