//
//  NetworkService.swift
//  AstroTest
//
//  Created by Екатерина Алексеева on 25.10.2024.
//

import Foundation
import UIKit

final class NetworkService {
    
    // MARK: - Static properties
    
    static let shared = NetworkService()
    
    // MARK: - Private properties
    
    private var gistsPage: Int = 1
    
    // MARK: - Properties
    
    var token: String? = TokenService.shared.token
    let imageCache = NSCache<NSString, UIImage>()
    
    // MARK: - Init
    
    private init() { }
    
    // MARK: - Open methods
    
    func fetchNextGistsPage(completion: @escaping (Result<[Gist], Error>) -> Void) {
        guard let request = setupRequest(for: .gists) else { return }
        fetch(request, completion: completion)
        gistsPage += 1
    }
    
    func fetchCommits(gistID: String, completion: @escaping (Result<[Commit], Error>) -> Void) {
        guard let request = setupRequest(for: .commits(gistID)) else { return }
        fetch(request, completion: completion)
    }
    
    func refreshGistsData(completion: @escaping (Result<[Gist], Error>) -> Void) {
        gistsPage = 1
        fetchNextGistsPage(completion: completion)
    }
    
    func loadImage(urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
            if let imageFromCache = self.imageCache.object(forKey: urlString as NSString) {
                completion(.success(imageFromCache))
            }
            if let data = data {
                let imageToCache = UIImage(data: data) ?? UIImage()
                self.imageCache.setObject(imageToCache, forKey: urlString as NSString)
                completion(.success(imageToCache))
            }
        }
        task.resume()
    }
    
    // MARK: - Private methods
    
    private func fetch<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<[T], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode([T].self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error decoding: \(error)")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func setupRequest(for typeOfRequest: TypeOfRequest) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        let path = getPath(for: typeOfRequest)
        urlComponents.path = path
        let queryItems = getQueryItems(for: typeOfRequest)
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(token ?? "")", forHTTPHeaderField: "Authorization")
        request.addValue("2022-11-28", forHTTPHeaderField: "X-GitHub-Api-Version")
        return request
    }
    
    private func getPath(for typeOfRequest: TypeOfRequest) -> String {
        var path: String = ""
        switch typeOfRequest {
        case .gists:
            path =  "/gists/public"
        case .commits(let id):
            path = "/gists/\(id)/commits"
        }
        return path
    }
    
    private func getQueryItems(for typeOfRequest: TypeOfRequest) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        switch typeOfRequest {
        case .gists:
            queryItems = [URLQueryItem(name: "per_page", value: "10"),
                          URLQueryItem(name: "page", value: "\(gistsPage)")]
        case .commits(_):
            queryItems = [URLQueryItem(name: "per_page", value: "10"),
                          URLQueryItem(name: "page", value: "1")]
        }
        return queryItems
    }
    
    // MARK: - Enum TypeOfRequest
    
    enum TypeOfRequest {
        case gists
        case commits(String)
    }
}
