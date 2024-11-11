//
//  TokenService.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 27.10.2024.
//

import Foundation

final class TokenService {
    
    // MARK: - Static properties
    
    static let shared = TokenService()
    
    // MARK: - Properties
    
    var token: String? {
        get {
            return UserDefaults.standard.object(forKey: "token") as? String
        }
        set {
            let token = newValue
            guard let token = token else { return }
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    // MARK: - Init
    
    private init() {
        self.token = UserDefaults.standard.object(forKey: "token") as? String
    }
}
