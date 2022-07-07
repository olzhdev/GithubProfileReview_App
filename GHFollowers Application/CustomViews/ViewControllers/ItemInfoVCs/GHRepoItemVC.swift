//
//  GHRepoItemVC.swift
//  GHFollowers Application
//
//  Created by MAC on 06.07.2022.
//

import UIKit

class GHRepoItemVC: GHItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(backgroundColor: .systemPurple, title: "Gihub Profile")
    }
    
    override func actionButtonTapped() {
        userInfoDelegate.didTapGetGitHubProfile(for: user)
    }
}
