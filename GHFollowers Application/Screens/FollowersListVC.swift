//
//  FollowersVC.swift
//  GHFollowers Application
//
//  Created by MAC on 03.07.2022.
//

import UIKit

protocol FollowersListVCDeleage: AnyObject {
    func didRequestFollowers(with username: String)
}

class FollowersListVC: UIViewController {
    
    enum Section { case main }
    
    var page = 1
    var hasMoreFollowers = true
    
    var userName: String!
    var followersList: [Follower] = []
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    var filteredFollowers: [Follower] = []
    
    var isSearching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureCollectionView()
        getFollowers(username: userName, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func getFollowers(username: String, page: Int) {
        showLoadingView()
        NetworkManager.shared.getFollowers(username: userName, page: page) { [weak self] result in
            self?.dismissLoadingView()
            
            guard let self = self else {return}
            switch result {
            case .success(let followers):
                if followers.count < 100 { self.hasMoreFollowers = false }
                self.followersList.append(contentsOf: followers)
                
                if self.followersList.isEmpty {
                    let message = "This user doesn't have any followers. Go follow them 😀"
                    DispatchQueue.main.async {
                        self.showEmptyStateView(message: message, in: self.view)
                    }
                    return
                }
                self.updateData(on: self.followersList)
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        self.showLoadingView()
        
        NetworkManager.shared.getUserInfo(username: userName) { [weak self] result in
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
                PersistenceManager.uptade(favorite: favorite, action: .add) { [weak self] error in
                    guard let self = self else { return }
                    guard let error = error else {
                        self.presentGFAlertOnMainThread(title: "Success!", message: "You successfully favorited this user", buttonTitle: "Ok")
                        return
                    }
                    
                    self.presentGFAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
                }
                
            case .failure(let error):
                self.presentGFAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    private func createThreeColumnFlowLayout() -> UICollectionViewLayout {
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimumItemSpacing: CGFloat = 10
        let availableWidth = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth = availableWidth / 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth + 40)
        
        return flowLayout
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            return cell
        })
    }
    
    func updateData(on followerArray: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followerArray)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }

}

extension FollowersListVC: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.height
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - height {
            guard hasMoreFollowers else {return}
            page += 1
            getFollowers(username: userName, page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray = isSearching ? filteredFollowers : followersList
        let follower = activeArray[indexPath.item]
        
        let destVC = UserInfoVC()
        destVC.userName = follower.login
        destVC.followerListVCDelegate = self
        let navVC = UINavigationController(rootViewController: destVC)
        present(navVC, animated: true)
    }
}

extension FollowersListVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {return}
        isSearching = true
        filteredFollowers = followersList.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followersList)
    }
}

extension FollowersListVC: FollowersListVCDeleage {
    func didRequestFollowers(with username: String) {
        self.userName = username
        title = username
        followersList.removeAll()
        filteredFollowers.removeAll()
        page = 1
        collectionView.setContentOffset(.zero, animated: true)
        getFollowers(username: username, page: page)
    }
}
