//
//  ViewController.swift
//  MoyaTest
//
//  Created by Artur Wiśniewski on 16/09/2020.
//  Copyright © 2020 Artur Wiśniewski. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, UserManagerDelegate {
    var userManager = UserManager()
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        userManager.delegate = self
        userManager.fetchUsers()
    }

//MARK: - UITableViewDelegate & DataSource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        userManager.update(user: user, at: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let user = users[indexPath.row]
        userManager.delete(user: user, at: indexPath.row)
    }

//MARK: - UserManagerDelegate Methods
    func didFetchUsers(_ users: [User]) {
        self.users = users
        self.tableView.reloadData()
    }
    
    func didCreateUser(_ user: User) {
        self.users.insert(user, at: 0)
        self.tableView.reloadData()
    }
    
    func didUpdateUser(_ user: User, at index: Int) {
        self.users[index] = user
        self.tableView.reloadData()
    }
    
    func didDeleteUser(at index: Int) {
        self.users.remove(at: index)
        self.tableView.reloadData()
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
       
//MARK: - IBActions Methods
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        let user = User(id: 55, name: "John Doe")
        userManager.createNew(user: user)
    }
    
//MARK: - Update UI Methods
    private func setNavBar() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .purple
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.tintColor = .white
        }
    }
}
