//
//  MovieTableViewCell.swift
//  assessment-movie-search
//
//  Created by Andrew Elliott on 4/8/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var parent: UIViewController?
    var movie: Movie? {
        didSet {
            updateViews()
        }
    }
    var movieImage: UIImage?
    
    // MARK: - Outlets
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    // MARK: - Helper Functions
    
    func updateViews() {
        guard let movie = movie else { return }
        
        MovieNetworkManager.fetchImage(for: movie, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.movieImage = image
                    self.posterImageView.image = self.movieImage
                case .failure(let error):
                    guard let parent = self.parent else { return }
                    
                    parent.presentErrorToUser(localizedError: error)
                }
            }
        })
        
        titleLabel.text = movie.title
        ratingLabel.text = movie.rating > 0 ? String(movie.rating) : "No rating"
        summaryLabel.text = movie.summary
    }
}
