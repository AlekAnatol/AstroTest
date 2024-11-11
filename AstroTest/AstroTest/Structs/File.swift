//
//  File.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import Foundation

struct File: Decodable {
    
    // MARK: - Properties
    
    let filename: String
    let type: String
    let rawUrl: String
    
    enum CodingKeys: String, CodingKey {
        case filename
        case type
        case rawUrl = "raw_url"
    }
}
