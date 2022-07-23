//
//  PersistenceManager.swift
//  GHFollowers Application
//
//  
//

import Foundation

/// Object to saved defaults
enum PersistenceManager {
    // MARK: - Properties
    
    ///  Instance of defaults
    static private let defaults = UserDefaults.standard
    ///  Keys
    enum Keys {
        static let favorites = "favorites"
    }
    /// Type of actions
    enum PersistenceManagerActions {
        case add, remove
    }
    
    
    ///  Retreive array of favorites by given key
    /// - Parameter completed: Callback
    static func retrieveFavorites(completed: @escaping (Result<[Follower], GHError>) -> Void) {
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
    
    /// Save array of favs to default
    /// - Parameter favorites: Array of favorites
    /// - Returns: <#description#>
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
    
    ///  Method for saving user to favorites
    /// - Parameters:
    ///   - favorite: Favorite user
    ///   - action: Add or Remove
    ///   - completed:  Callback (if succes = error nil)
    static func uptade(favorite: Follower, action: PersistenceManagerActions, completed: @escaping (GHError?) -> Void) {
        
        retrieveFavorites { result in
            
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
