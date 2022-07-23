//
//  UserInfoVC.swift
//  GHFollowers Application
//
//  
//

import UIKit

/// User Information VC
class UserInfoVC: UIViewController {
    
    // MARK: - Properties and elements
    
    /// Header view
    let headerView = UIView()
    /// Item views in Header view
    let itemViewOne = UIView()
    let itemViewTwo = UIView()
    /// Date label
    let dateLabel = GHBodyLabel(textAlignment: .center)
    /// Username
    var userName: String!    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        getUserInfo()
        configureViewController()
        constraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    // MARK: - Inits
    
    init(username: String) {
        super.init(nibName: nil, bundle: nil)
        self.userName = username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    
    /// Configuration of screen
    private func configureViewController() {
        view.backgroundColor = .systemBackground
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addButtonTapped() {
        self.showLoadingView()
        
        APICaller.shared.getUserInfo(username: userName) { [weak self] result in
            guard let self = self else {return}
            
            self.dismissLoadingView()
            
            switch result {
            case .success(let user):
                self.addUserToFavorite(user: user)
                
            case .failure(let error):
                self.presentGHAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    /// Fetch user info
    private func getUserInfo() {
        
        APICaller.shared.getUserInfo(username: userName) { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let user):
                DispatchQueue.main.async { self.configureUIElements(with: user) }
                
            case .failure(let error):
                self.presentGHAlertOnMainThread(title: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    /// Adds user to favorites
    /// - Parameter user: User model
    private func addUserToFavorite(user: User) {
        
        let favorite = Follower(login: user.login, avatarUrl: user.avatarUrl)
        PersistenceManager.uptade(favorite: favorite, action: .add) { [weak self] error in
            guard let self = self else { return }
            guard let error = error else {
                self.presentGHAlertOnMainThread(title: "Success!", message: "You successfully favorited this user", buttonTitle: "Ok")
                return
            }
            
            self.presentGHAlertOnMainThread(title: "Something went wrong!", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    /// Adds VCs to given container view
    /// - Parameters:
    ///   - childVC: Which VC to add
    ///   - containerView: Where to add
    private func add(childVC: UIViewController, to containerView: UIView) {
        addChild(childVC)
        containerView.addSubview(childVC.view)
        childVC.view.frame = containerView.bounds
        childVC.didMove(toParent: self)
    }
    

    
    /// Configure custom-dynamic UI elements
    /// - Parameter user: User model
    private func configureUIElements(with user: User) {
        
        let repoItemVC = GHRepoItemVC(user: user)
        repoItemVC.GHRepoItemVCProtocolDelegate = self
        
        let followerItemVC = GHFollowerItemVC(user: user)
        followerItemVC.GHFollowerItemVCDelegate = self
        
        self.add(childVC: GHUserInfoHeaderVC(user: user), to: self.headerView)
        self.add(childVC: repoItemVC, to: self.itemViewOne)
        self.add(childVC: followerItemVC, to: self.itemViewTwo)
        self.dateLabel.text = "GitHub since \(user.createdAt.convertToMonthYear())"
    }
    
    
    private func constraint(){
        view.addSubview(headerView)
        view.addSubview(itemViewOne)
        view.addSubview(itemViewTwo)
        view.addSubview(dateLabel)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        itemViewOne.translatesAutoresizingMaskIntoConstraints = false
        itemViewTwo.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let padding: CGFloat = 20
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 210),
            
            itemViewOne.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: padding),
            itemViewOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewOne.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewOne.heightAnchor.constraint(equalToConstant: 140),

            itemViewTwo.topAnchor.constraint(equalTo: itemViewOne.bottomAnchor, constant: padding),
            itemViewTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            itemViewTwo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            itemViewTwo.heightAnchor.constraint(equalToConstant: 140),
            
            dateLabel.topAnchor.constraint(equalTo: itemViewTwo.bottomAnchor, constant: padding),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            dateLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
}


// MARK: - Extensions

extension UserInfoVC: GHFollowerItemVCDelegate, GHRepoItemVCDelegate {
    
    /// Method when click to GetFollower button
    /// - Parameter user: User model
    func didTapGetFollowersButton(for user: User) {
        
        guard user.followers != 0 else {
            presentGHAlertOnMainThread(title: "No followers", message: "User has no followers.", buttonTitle: "Ok")
            return
        }
        
        let followerListVC = FollowersListVC(username: user.login)
        navigationController?.pushViewController(followerListVC, animated: true)
        dismissVC()
    }
    
    /// Method when clikc to GoProfile button
    /// - Parameter user: User model
    func didTapGetGitHubProfile(for user: User) {
        
        guard let url = URL(string: user.htmlUrl) else {
            presentGHAlertOnMainThread(title: "Invalid URL", message: "The url attached to user is invalid.", buttonTitle: "Ok")
            return
        }
        presentSafariVC(with: url)
    }
}

