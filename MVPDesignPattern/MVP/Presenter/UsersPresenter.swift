//
//  UsersPresenter.swift
//  MVPDesignPattern
//
//  Created by Олег Федоров on 04.09.2022.
//

import UIKit

let url = "https://jsonplaceholder.typicode.com/users"

protocol UserPresenterDelegate: AnyObject {
    func presentUsers(users: [User])
    func presentAlert(title: String, message: String)
}

typealias PresenterDelegate = UserPresenterDelegate & UIViewController

class UsersPresenter {
    
    weak var delegate: PresenterDelegate?
    
    public func setViewDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
    
    public func getUsers() {
        guard let url = URL(string: url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let users = try JSONDecoder().decode([User].self, from: data)
                self?.delegate?.presentUsers(users: users)
            } catch {
                print(error.localizedDescription )
            }
        }
        task.resume()
    }
    
    public func didTap(user: User) {
        delegate?.presentAlert(
            title: user.name,
            message: "\(user.name) has an email of \(user.email) & a username of \(user.username)"
        )
    }
}
