//
//  MovieNetworkManager.swift
//  assessment-movie-search
//
//  Created by Andrew Elliott on 4/8/22.
//

import Foundation
import UIKit

class MovieNetworkManager {
    static func fetchMovies(with searchTerm: String, completion: @escaping (Result<[Movie], MovieError>) -> Void) {
        
        guard var components = URLComponents(string: Strings.baseURL) else { return completion(.failure(.invalidURL)) }
        
        components.path.append(contentsOf: Strings.apiVersion)
        components.path.append(contentsOf: Strings.searchEnpoint)
        components.path.append(contentsOf: Strings.movieEndpoint)
        components.queryItems = [URLQueryItem(name: Strings.apiKeyQuery, value: Strings.apiKey), URLQueryItem(name: Strings.queryQuery, value: searchTerm)]
        
        guard let finalURL = components.url else { return completion(.failure(.invalidURL)) }
        
        URLSession.shared.dataTask(with: finalURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return completion(.failure(.thrownError(error)))
            } else {
                guard let data = data else { return completion(.failure(.noData)) }
                
                do {
                    let topLevelObject = try JSONDecoder().decode(TopLevelObject.self, from: data)
                    completion(.success(topLevelObject.results))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(.thrownError(error)))
                }
            }
        }.resume()
    }
    
    static func fetchImage(for movie: Movie, completion: @escaping (Result<UIImage, MovieError>) -> Void) {
        
        guard var components = URLComponents(string: Strings.imageBaseURL) else { return completion(.failure(.invalidURL)) }
        
        components.path.append(contentsOf: movie.imageURL)
        
        guard let finalURL = components.url else { return completion(.failure(.invalidURL)) }
        
        do {
            let imageData = try Data(contentsOf: finalURL)
            if let image = UIImage(data: imageData) {
                return completion(.success(image))
            } else {
                return completion(.failure(.invalidURL))
            }
        } catch {
            print(error.localizedDescription)
            completion(.failure(.thrownError(error)))
        }
    }
}
