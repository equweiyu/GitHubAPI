//
//  HistoryViewController.swift
//  GitHubAPI
//
//  Created by 白天伟 on 2020/12/24.
//

import UIKit

class HistoryViewController: UIViewController {
    let cellReuseIdentifier = "History"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        return tableView
    }()
    
    var dataSource: [(String,Data)] = []

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true

    }
    override func viewWillAppear(_ animated: Bool) {
        loadDataSource()
    }
    
    func loadDataSource() {
        self.dataSource = HistoryManage.shared.history
        self.tableView.reloadData()
    }
    
}
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        let model = dataSource[indexPath.row]
        cell.textLabel?.text = model.0
        return cell
    }
}
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        let next = APIViewController()
        next.resultModel = model

        self.navigationController?.pushViewController(next, animated: true)
    }
}
