//
//  GHFollowerItemVC.swift
//  GHFollowers Application
//
//  Created by MAC on 06.07.2022.
//

import UIKit

class GHFollowerItemVC: GHItemInfoVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureItems()
    }
    
    func configureItems(){
        itemInfoViewOne.set(itemInfoType: .followers, withCount: user.followers)
        itemInfoViewTwo.set(itemInfoType: .following, withCount: user.following)
        actionButton.set(backgroundColor: .systemGreen, title: "Get Followers")
    }
}
