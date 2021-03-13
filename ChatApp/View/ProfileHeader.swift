//
//  ProfileHeader.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit
import Firebase

class ProfileHeader: UIView {
    
    private let profileImageViewSize: CGFloat = 80
    
    private var profileImageView: WebImageView = {
        let iv = WebImageView()
//        iv.image = UIImage(named: "Clogo")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBackground
        return iv
    }()
    
    private var initialsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        return label
    }()
    
    private var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        heightAnchor.constraint(equalToConstant: 180).isActive = true
        backgroundColor = .secondarySystemBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor,
                                paddingTop: 16,
                                width: profileImageViewSize,
                                height: profileImageViewSize)
        profileImageView.centerX(inView: self)
        profileImageView.layer.cornerRadius = profileImageViewSize / 2
        
        profileImageView.addSubview(initialsLabel)
        initialsLabel.anchor(width: profileImageViewSize,
                             height: profileImageViewSize)
        initialsLabel.centerX(inView: profileImageView)
        initialsLabel.centerY(inView: profileImageView)
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImageView.bottomAnchor,
                             left: self.leftAnchor,
                             right: self.rightAnchor,
                             paddingTop: 12,
                             paddingLeft: 12,
                             paddingRight: 12)
    }
    
    func configureProfileHeader(withUid uid: String, withUserName userName: String?, withInitials initials: String, withImageUrl imageUrl: String?) {
        
        print("configureProfileHeader")
        print(uid)
        
        if userName != nil {
            userNameLabel.text = userName
        } else {
            userNameLabel.text = "Пользователь №\(uid)"
        }
        
        if imageUrl != nil {
            profileImageView.set(imageURL: imageUrl)
        } else {
            initialsLabel.text = initials
        }
        
    }
    
}
