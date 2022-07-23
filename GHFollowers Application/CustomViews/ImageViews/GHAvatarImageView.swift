//
//  GHAvatarImageView.swift
//  GHFollowers Application
//
//  
//

import UIKit

class GHAvatarImageView: UIImageView {
    // MARK: - Properties
    
    /// Instance of cache
    let cache = APICaller.shared.cache
    /// Placegolder image
    let placeholderImage = Images.placeholder
    
    
    // MARK: - Inits

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Private
    
    /// Layout configuration
    private func configureUI() {
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    // MARK: - Public
    
    /// Method for downloading image
    /// - Parameter url: URL of image
    public func downloadImage(fromURL url: String) {
        APICaller.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async { self.image = image }
        }
    }
}
