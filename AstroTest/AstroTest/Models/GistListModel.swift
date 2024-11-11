//
//  GistListModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 26.10.2024.
//

import Foundation

class GistListModel {
    
    // MARK: - Private properties
    
    private var privateGistList: [Gist] = []
    private let network = NetworkService.shared
    
    // MARK: - Properties
    
    var gistList: [Gist] {
        return privateGistList
    }
    
    // MARK: - Init
    
    init() {
    }
    
    // MARK: - Open methods
    
    func fetchNextGistsPage(completion: @escaping () -> Void) {
        network.fetchNextGistsPage() { result in
            switch result {
            case .success(let gists):
                self.privateGistList.append(contentsOf: gists)
                completion()
            case .failure(let error):
                print("Error fetching commits: \(error)") // Log error
            }
        }
    }
    
    func refreshGists(completion: @escaping () -> Void) {
        network.refreshGistsData { result in
            switch result {
            case .success(let gists):
                self.privateGistList = gists
                completion()
            case .failure(let error):
                print("Error fetching commits: \(error)")
            }
        }
    }
}
