//
//  FollowersVC.swift
//  GHFollowers Application
//
//  
//

import UIKit


/// Collection view of followers
class FollowersListVC: UIViewController {
    
    // MARK: - Properties
    /// Section for diffable data source
    enum Section { case main }
    
    /// Page number, for pagination functional
    var page = 1
    /// Flag to check followes
    var hasMoreFollowers = true
    
    /// Username
    var userName: String!
    /// List of followers model
    var followersList: [Follower] = []
    
    /// Main view
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Follower>!
    
    /// List of filtered followers (when searching)
    var filteredFollowers: [Follower] = []
    
    /// Flag to check is user searching or not
    var isSearching = false

    
    // MARK: - Inits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)

        configureViewController()
        configureCollectionView()
        getFollowers(username: userName, page: page)
        configureDataSource()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = username
        title = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    
    /// Fetching user's followers
    /// - Parameters:
    ///   - username: Username
    ///   - page: Page number to fetch
    private func getFollowers(username: String, page: Int) {
        showLoadingView()
        
        APICaller.shared.getFollowers(username: userName, page: page) { [weak self] result in
            guard let self = self else {return}
            self.dismissLoadingView()
            
            switch result {
            case .success(let followers):
                self.updateUI(with: followers)
                
            case .failure(let error):
                self.presentGHAlertOnMainThread(title: "Bad Stuff Happened", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    /// Updates UI with data
    /// - Parameter followers: Followers array
    private func updateUI(with followers: [Follower]) {
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
    }
    
    /// Updates collection view
    /// - Parameter followerArray: Array of followers model
    private func updateData(on followerArray: [Follower]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Follower>()
        snapshot.appendSections([.main])
        snapshot.appendItems(followerArray)
        DispatchQueue.main.async {
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
    
    /// VC configuration
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Main collection view configuration
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createThreeColumnFlowLayout())
        collectionView.register(FollowerCell.self, forCellWithReuseIdentifier: FollowerCell.reuseID)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
    }
    
    /// Creates layout of collection view
    /// - Returns: FlowLayout
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
    
    /// Configures data source with model
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Follower>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, follower) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerCell.reuseID, for: indexPath) as! FollowerCell
            cell.set(follower: follower)
            
            return cell
        })
    }
    
    /// Configures search controller
    private func configureSearchController() {
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a username"
        navigationItem.searchController = searchController
    }

}


// MARK: - Extensions

extension FollowersListVC: UICollectionViewDelegate {
    
    ///  Check is user scrolled to the bottom and fetch next page of followers
    /// - Parameters:
    ///   - scrollView: Ref to scroll view
    ///   - decelerate:  Bool
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
        
        let destVC = UserInfoVC(username: follower.login)
        
        navigationController?.pushViewController(destVC, animated: true)
    }
}


extension FollowersListVC: UISearchResultsUpdating {
    
    /// Filter array when user typing and searching something
    /// - Parameter searchController: Ref to SearchController
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else {
            filteredFollowers.removeAll()
            updateData(on: followersList)
            isSearching = false
            return
        }
        
        isSearching = true
        filteredFollowers = followersList.filter({ $0.login.lowercased().contains(filter.lowercased()) })
        updateData(on: filteredFollowers)
    }
    
    /// Cancel button clicked
    /// - Parameter searchBar: Ref to search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: followersList)
    }
}

