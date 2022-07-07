//
//  FavoritesListVC.swift
//  GHFollowers Application
//
//  Created by MAC on 03.07.2022.
//

import UIKit

class FavoritesListVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBlue
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let favorites): print(favorites)
            case .failure(let error): print(error)
            }
        }
    }


}
