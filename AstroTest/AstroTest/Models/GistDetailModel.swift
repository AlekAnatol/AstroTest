//
//  GistDetailModel.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 30.10.2024.
//

import Foundation

class GistDetailModel {
    
    // MARK: - Private properties
    
    private var privateGist: Gist
    private var privateCommits: [Commit] = []
    private var privateFilesDictionaryValues: [File] = []
    private let network = NetworkService.shared
    
    // MARK: - Properties
    
    var gist: Gist {
        return privateGist
    }
    var commits: [Commit] {
        return privateCommits
    }
    var filesDictionaryValues: [File] {
        return privateFilesDictionaryValues
    }
    
    // MARK: - Init
    
    init(gist: Gist, completion: @escaping (GistDetailModel) -> Void) {
        self.privateGist = gist
        privateFilesDictionaryValues = Array(privateGist.files.values)
        if privateFilesDictionaryValues.count > 5 {
            self.privateFilesDictionaryValues = Array(privateFilesDictionaryValues[0..<5])
        }
        fetchCommits { commits in
            self.privateCommits = commits
            completion(self)
        }
    }
    
    // MARK: - Open methods
    
    func refreshCommits(completion: @escaping () -> Void) {
        network.fetchCommits(gistID: gist.id) { result in
            switch result {
            case .success(let commits):
                self.privateCommits = commits
                completion()
            case .failure(let error):
                print("Error fetching commits: \(error)")
            }
        }
    }
    
    // MARK: - Private methods
    
    private func fetchCommits(completion: @escaping ([Commit]) -> Void) {
        network.fetchCommits(gistID: gist.id) { result in
            switch result {
            case .success(let commits):
                completion(commits)
            case .failure(let error):
                print("Error fetching commits: \(error)")
            }
        }
    }
}
