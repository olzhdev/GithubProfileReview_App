//
//  SearchVC.swift
//  GHFollowers Application
//
//  
//

import UIKit

/// First screen
class SearchVC: UIViewController {
    
    // MARK: - Properties and elements
    let logoImageView = UIImageView()
    let usernameTextField = GHTextField()
    let callToActionButton = GHButton(color: .systemGreen, title: "Get Followers!")
    
    /// Flag to check is textfield is empty
    var isUsernameEntered: Bool { return usernameTextField.text!.isEmpty }
    
    
    // MARK: - Lifcycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureUI()
        constraint()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    // MARK: - Private
    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func pushFollowerListVC() {
        guard !isUsernameEntered else
        {
            presentGHAlertOnMainThread(title: "Empty Username", message: "Please enter the username. We need to know who to look for", buttonTitle: "Ok")
            return
        }
        
        usernameTextField.resignFirstResponder()
        
        let userInfoVC = UserInfoVC(username: usernameTextField.text!)
        
        navigationController?.pushViewController(userInfoVC, animated: true)
    }
    
    
    private func configureUI() {
        logoImageView.image = Images.ghLogo
        usernameTextField.delegate = self
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
    }
    
    
    private func constraint() {
        view.addSubview(logoImageView)
        view.addSubview(usernameTextField)
        view.addSubview(callToActionButton)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 44),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

}

// MARK: - Extensions

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
