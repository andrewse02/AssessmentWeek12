//
//  Movie.swift
//  assessment-movie-search
//
//  Created by Andrew Elliott on 4/8/22.
//

import Foundation

struct TopLevelObject: Codable {
    let results: [Movie]
    let totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}

struct Movie: Codable {
    let title: String
    let summary: String
    let rating: Double
    let imageURL: String
    
    private enum CodingKeys: String, CodingKey {
        case title
        case summary = "overview"
        case rating = "vote_average"
        case imageURL = "poster_path"
    }
}
