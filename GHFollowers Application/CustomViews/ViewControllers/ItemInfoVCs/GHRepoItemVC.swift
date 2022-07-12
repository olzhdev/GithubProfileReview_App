//
//  GHRepoItemVC.swift
//  GHFollowers Application
//
//  Created by MAC on 06.07.2022.
//

import UIKit

protocol GHRepoItemVCDelegate: AnyObject {
    func didTapGetGitHubProfile(for user: User)
}

class GHRepoItemVC: GHItemInfoVC {
    weak var GHRepoItemVCProtocolDelegate: GHRepoItemVCDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Gihub Profile")
    }
    
    override func actionButtonTapped() {
        GHRepoItemVCProtocolDelegate.didTapGetGitHubProfile(for: user)
    }
}
