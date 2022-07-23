//
//  GFButton.swift
//  GHFollowers Application
//
//  
//

import UIKit

/// Custom button
class GHButton: UIButton {
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String) {
        self.init(frame: .zero)
        set(color: color, title: title)
    }
    
    
    // MARK: - Public
    public func set(color: UIColor, title: String) {
        configuration?.title = title
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = color
    }
    
    
    // MARK: - Private
    private func configureUI() {
        configuration?.cornerStyle = .medium
        configuration = .tinted()
        translatesAutoresizingMaskIntoConstraints = false
    }
    

}
