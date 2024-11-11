//
//  Owner.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import Foundation

struct Owner: Decodable {
    
    // MARK: - Properties
    
    let login: String?
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
    }
}
