//
//  SettingsViewController.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private var user: User

    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureNavigationBar()
        configureSwipeGesture()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        
        navigationItem.title = "Settings"
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Functions
        
    private func configureSwipeGesture() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
    }
    
}
