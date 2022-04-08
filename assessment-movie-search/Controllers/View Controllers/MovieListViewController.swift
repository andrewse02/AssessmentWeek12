//
//  MovieListTableViewController.swift
//  assessment-movie-search
//
//  Created by Andrew Elliott on 4/8/22.
//

import UIKit

class MovieListViewController: UIViewController {
    
    // MARK: - Properties
    
    var movies: [Movie] = [] {
        didSet {
            // reload table
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var movieListTableView: UITableView!
    
    // MARK: - Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieListTableView.dataSource = self
        searchBar.delegate = self
    }
}

extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell", for: indexPath) as? MovieTableViewCell else { return UITableViewCell() }
        
        cell.parent = self
        cell.movie = movies[indexPath.row]
        
        return cell
    }
}

// lost
extension MovieListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
    }
    
}

extension MovieListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty else { return }
        
        MovieNetworkManager.fetchMovies(with: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedMovies):
                    self.movies = fetchedMovies
                    self.movieListTableView.reloadData()
                case .failure(let error):
                    self.presentErrorToUser(localizedError: error)
                }
            }
        }
    }
}
