//
//  PersistenceManager.swift
//  GHFollowers Application
//
//  Created by MAC on 07.07.2022.
//

import Foundation

enum PersistenceManagerActions {
    case add, remove
}

enum PersistenceManager {
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func retreieveData(completed: @escaping (Result<[Follower], GHError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Follower].self, from: favoritesData)
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Follower]) -> GHError? {
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func uptade(favorite: Follower, action: PersistenceManagerActions, completed: @escaping (GHError?) -> Void) {
        
        retreieveData { result in
            
            switch result {
            case .success(let favorites):
                var retreivedFavorites = favorites
                switch action {
                case .add:
                    guard !retreivedFavorites.contains(favorite) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    
                    retreivedFavorites.append(favorite)
                    
                case .remove:
                    retreivedFavorites.removeAll { $0.login == favorite.login }
                }
                
                completed(save(favorites: retreivedFavorites))
                
            case .failure(let error): completed(error)
            }
        }
    }
}
