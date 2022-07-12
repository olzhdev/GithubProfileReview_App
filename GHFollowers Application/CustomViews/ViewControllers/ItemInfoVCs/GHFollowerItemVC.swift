//
//  GHFollowerItemVC.swift
//  GHFollowers Application
//
//  Created by MAC on 06.07.2022.
//

import UIKit

protocol GHFollowerItemVCDelegate: AnyObject {
    func didTapGetFollowersButton(for user: User)
}


class GHFollowerItemVC: GHItemInfoVC {
    weak var GHFollowerItemVCDelegate: GHFollowerItemVCDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(color: .systemGreen, title: "Get Followers")
    }
    
    override func actionButtonTapped() {
        GHFollowerItemVCDelegate.didTapGetFollowersButton(for: user)
    }
}
