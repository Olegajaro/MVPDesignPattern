//
//  ViewController.swift
//  MVPDesignPattern
//
//  Created by Олег Федоров on 04.09.2022.
//

import UIKit

class UsersViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let userPresenter = UsersPresenter()
    private var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        userPresenter.setViewDelegate(delegate: self)
        userPresenter.getUsers()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension UsersViewController: UserPresenterDelegate {
    func presentUsers(users: [User]) {
        self.users = users
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

extension UsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

extension UsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        userPresenter.didTap(user: users[indexPath.row])
    }
}
