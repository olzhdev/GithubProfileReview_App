//
//  GHFollowerItemVC.swift
//  GHFollowers Application
//
//  
//

import UIKit

protocol GHFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowersButton(for user: User)
}

/// Inherits from GHItemInfoVC
class GHFollowerItemVC: GHItemInfoVC {
    
    /// Delegate
    weak var GHFollowerItemVCDelegate: GHFollowerItemVCDelegate!
    
    /// Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    /// Sets items
    func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers")
    }
    /// Button tapped
    override func actionButtonTapped() {
        GHFollowerItemVCDelegate.didTapGetFollowersButton(for: user)
    }
}
