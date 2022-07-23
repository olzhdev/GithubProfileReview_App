//
//  GHRepoItemVC.swift
//  GHFollowers Application
//
//  
//

import UIKit

protocol GHRepoItemVCDelegate: AnyObject {
    func didTapGetGitHubProfile(for user: User)
}

/// Inherits from GHItemInfoVC
class GHRepoItemVC: GHItemInfoVC {
    
    /// Delegate
    weak var GHRepoItemVCProtocolDelegate: GHRepoItemVCDelegate!
    
    /// Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    /// Sets items
    private func configureItems(){
        itemInfoViewOne.set(itemInfoType: .repos, withCount: user.publicRepos)
        itemInfoViewTwo.set(itemInfoType: .gists, withCount: user.publicGists)
        actionButton.set(color: .systemPurple, title: "Gihub Profile")
    }
    
    /// Button tapped
    override func actionButtonTapped() {
        GHRepoItemVCProtocolDelegate.didTapGetGitHubProfile(for: user)
    }
}
