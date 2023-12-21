//
//  MovieTableViewCell.swift
//  CoreDataFavoriteMovies
//
//  Created by Parker Rushton on 10/31/22.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    static let reuseIdentifier = "MovieTableViewCell"
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!

    var onFavorite: (() -> Void)?
     
     private var apiMovie: APIMovie?
     private var coreDataMovie: Movie?
     
     private var heart = UIImage(systemName: "heart")
     private var favoritedHeart = UIImage(systemName: "heart.fill")
     private let placeholder = UIImage(named: "moviePlaceholder")
     
    func update(with apiMovie: APIMovie, onFavorite: (() -> Void)?) {
        self.apiMovie = apiMovie
        self.coreDataMovie = nil
        self.onFavorite = onFavorite
        posterImageView.kf.setImage(with: apiMovie.posterURL, placeholder: placeholder)
        titleLabel.text = apiMovie.title
        yearLabel.text = apiMovie.year
        setUnFavorite() // By default, set as not favorite for API movies
    }

    func update(with coreDataMovie: Movie, onFavorite: (() -> Void)?) {
          self.coreDataMovie = coreDataMovie
          self.apiMovie = nil
          self.onFavorite = onFavorite
         // Use URL initialization if you have posterURLString in your Movie entity
          posterImageView.kf.setImage(with: URL(string: coreDataMovie.posterURLString ?? ""), placeholder: placeholder)
//         posterImageView.kf.setImage(with: coreDataMovie.posterURL, placeholder: placeholder)
         titleLabel.text = coreDataMovie.title
         yearLabel.text = coreDataMovie.year
         if coreDataMovie.isFavorite {
              setFavorite()
          } else {
              setUnFavorite()
          }
      }
     

    func setFavorite() {
           heartButton.setImage(favoritedHeart, for: .normal)
           heartButton.tintColor = .red
       }

       func setUnFavorite() {
           heartButton.setImage(heart, for: .normal)
           heartButton.tintColor = .gray
       }
     
     @IBAction func favoriteButtonPressed() {
         onFavorite?()
     }
     
 }
