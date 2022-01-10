//
//  ListViewController.swift
//  RemoteCore_Example
//
//  Created by GBS Technology on 6/1/22.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    private let tableView = UITableView()
    
    private let viewModel = BaseViewModel<Post>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupViewModel()
        // Do any additional setup after loading the view.
    }
    
    
    
    func configUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    
    
    func setupViewModel () {
        
        viewModel.onLoading = {
            
        }
        
        viewModel.onError = {
            _ in
        }
        
        viewModel.onComplete = {
            self.tableView.reloadData()
        }
        
        viewModel.fetchItems()
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}



extension ListViewController : UITableViewDelegate {}


extension ListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.items[indexPath.row].title
        return cell
    }
}
