//
//  UserManager.swift
//  MoyaTest
//
//  Created by Artur Wiśniewski on 16/09/2020.
//  Copyright © 2020 Artur Wiśniewski. All rights reserved.
//

import Foundation
import Moya

protocol UserManagerDelegate {
    func didFetchUsers(_ users: [User])
    func didCreateUser(_ user: User)
    func didUpdateUser(_ user: User, at index: Int)
    func didDeleteUser(at index: Int)
    func didFailWithError(error: Error)
}


struct UserManager {
    let userProvider = MoyaProvider<UserService>()
    var delegate: UserManagerDelegate?

//MARK: - request methods
    func fetchUsers() {
        userProvider.request(.readUsers) { (result) in
            switch result {
            case .success(let response):
                if let users = self.parseUserList(from: response.data) {
                    self.delegate?.didFetchUsers(users)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func createNew(user: User){
        userProvider.request(.createUser(name: user.name)) { (result) in
            switch result {
            case .success(let response):
                if let newUser = self.parseUser(from: response.data) {
                    self.delegate?.didCreateUser(newUser)
                }
            case .failure(let error):
                 self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func update(user: User, at index: Int) {
        userProvider.request(.updateUser(id: user.id, name: "[Modified] " + user.name)) { (result) in
            switch result {
            case .success(let response):
                if let modifiedUser = self.parseUser(from: response.data) {
                    self.delegate?.didUpdateUser(modifiedUser, at: index)
                }
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

    func delete(user: User, at index: Int) {
        userProvider.request(.deleteUser(id: user.id)) { (result) in
            switch result {
            case .success(_):
                self.delegate?.didDeleteUser(at: index)
            case .failure(let error):
                self.delegate?.didFailWithError(error: error)
            }
        }
    }

//MARK: - parse JSON methods
    private func parseUserList(from userData: Data) -> [User]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([User].self, from: userData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }

    private func parseUser(from userData: Data) -> User? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(User.self, from: userData)
            return decodedData
        } catch {
            print(error)
        }
        return nil
    }
}
