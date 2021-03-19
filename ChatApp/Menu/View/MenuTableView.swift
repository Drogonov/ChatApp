//
//  MenuTableView.swift
//  ChatApp
//
//  Created by Admin on 13.03.2021.
//

import UIKit

enum MenuOptions: Int, CaseIterable, CustomStringConvertible {
    case Settings
    case Logout
    
    var description: String {
        switch self {
        case .Settings: return "Settings"
        case .Logout: return "Logout"
        }
    }
}

protocol MenuTableViewDelegate: class {
    func handleSettingsToggle()
    func handleLogoutToggle()
}

class MenuTableView: UIView {
    
    weak var delegate: MenuTableViewDelegate?
    
    private let defaultCell = "DefaultCell"
    
    private var user: User
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var profileHeader = ProfileHeader()
        
    init(frame: CGRect, user: User) {
        self.user = user
        super.init(frame: frame)
        configureUI()
        print("MenuTableView")
        print(user)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: defaultCell)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        
        tableView.backgroundColor = .secondarySystemBackground
        tableView.contentInsetAdjustmentBehavior = .never
        
        addSubview(tableView)
        tableView.anchor(top: self.topAnchor,
                         left: self.leftAnchor,
                         bottom: self.bottomAnchor,
                         right: self.rightAnchor)
        
        tableView.tableFooterView = UIView()

        tableView.reloadData()
        
        configureHeader()
        
    }
    
    func configureHeader() {
        profileHeader.configureProfileHeader(withUid: user.uid,
                                             withUserName: user.fullname,
                                             withInitials: user.initialForProfileImage,
                                             withImageUrl: user.profileImageUrl)
    }
    
}

extension MenuTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: defaultCell, for: indexPath)
        cell.textLabel?.text = MenuOptions(rawValue: indexPath.row)?.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate?.handleSettingsToggle()
        case 1:
            delegate?.handleLogoutToggle()
        default:
            break
        }
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return profileHeader
    }
}
