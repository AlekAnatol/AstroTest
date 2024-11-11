//
//  Gist.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import Foundation

struct Gist: Decodable {
    
    // MARK: - Properties
    
    let id: String
    let description: String?
    let owner: Owner
    let files: [String: File]
    let commitsUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case owner
        case files
        case commitsUrl = "commits_url"
    }
}
