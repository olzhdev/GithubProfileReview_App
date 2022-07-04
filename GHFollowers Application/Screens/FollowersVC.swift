//
//  FollowersVC.swift
//  GHFollowers Application
//
//  Created by MAC on 03.07.2022.
//

import UIKit

class FollowersVC: UIViewController {
    
    var userName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        NetworkManager.shared.getFollowers(username: userName, page: 1) { followers, errorMessage in
            guard let followers = followers else {
                self.presentGFAlertOnMainThread(title: "Bad stuff happened", message: errorMessage!.rawValue, buttonTitle: "Ok")
                return
            }
            print(followers.count)
            print(followers)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

}
