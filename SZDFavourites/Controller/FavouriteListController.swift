//
//  FavouriteListController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  Favourites List Controller is the main view.
//  The user should be able to do everything in this single view.
//  Features:
//      - Settings
//      - Add Thing
//      - View list of Things
//      - Edit Thing
//  Later:
//      - Add Group
//      - View groups

import Foundation
import UIKit

class FavouriteListController: UIViewController {
    
    var tableView = FavouriteListTableView()
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        self.title = "Favorites"
        self.view.backgroundColor = Color.Base.background
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.constrainTo(view: self.view, on: .all)
    }
}

extension FavouriteListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: self.tableView.reuseIdentifier)
        
        let index = ThingIndex(indexPath.section, indexPath.row)
        let thing = self.viewModel.thing(at: index)
        let item = thing.topItem()
        
        cell.textLabel?.text = thing.name
        cell.detailTextLabel?.text = item?.name ?? "-"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.groups[section].count
    }
}

extension FavouriteListController: UITableViewDelegate {
    
}

