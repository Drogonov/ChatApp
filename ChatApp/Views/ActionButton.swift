//
//  ActionButton.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit

class ActionButton: UIButton {
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        backgroundColor = .systemRed
        setTitleColor(.white, for: .normal)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
