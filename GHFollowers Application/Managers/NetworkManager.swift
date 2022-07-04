//
//  NetworkManager.swift
//  GHFollowers Application
//
//  Created by MAC on 04.07.2022.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    let baseUrl = "https://api.github.com/users/"
    
    func getFollowers(username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void) {
        let endpoint = baseUrl + "\(username)/followers?per_page=100&page=\(page)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, "This username created invalid request. Please try again.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error {
                completed(nil, "Unable to complete request. Please check your internet connection.")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from server. Please try again.")
                return
            }
            
            guard let data = data else {
                completed(nil, "Data received from server was invalid. Please try again.")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)
                completed(followers, nil)
            } catch {
                completed(nil, "Data received from server was invalid. Please try again.")
            }
            
        }
        task.resume()
    }
}
