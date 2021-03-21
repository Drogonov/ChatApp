//
//  ChatCell.swift
//  ChatApp
//
//  Created by Admin on 18.03.2021.
//

import UIKit
import Firebase

class ChatCell: UICollectionViewCell {

    // MARK: - Properties

    static let reuseId = "ChatCell"

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?

    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()

    let textView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        return tv
    }()

    let profileImageView: WebImageView = {
        let iv = WebImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()

    private var initialsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = ""
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)

        profileImageView.anchor(left: leftAnchor, bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4, width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2

        // bubble view right anchor
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleViewRightAnchor?.isActive = true

        // bubble view left anchor
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        bubbleViewLeftAnchor?.isActive = false

        // bubble view width and top anchor
        bubbleView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        // bubble view text view anchors
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

        profileImageView.addSubview(initialsLabel)
        initialsLabel.anchor(width: 32,
                             height: 32)
        initialsLabel.centerX(inView: profileImageView)
        initialsLabel.centerY(inView: profileImageView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        initialsLabel.text = ""
        textView.text = ""
        profileImageView.image = UIImage()
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(text: String, initials: String, imageUrl: String?) {
        textView.text = text
        if imageUrl != nil {
            profileImageView.set(imageURL: imageUrl)
        } else {
            initialsLabel.text = initials
        }
    }
}
