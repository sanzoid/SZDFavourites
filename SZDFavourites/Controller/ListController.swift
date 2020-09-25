//
//  ListController.swift
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

class ListController: UIViewController {
    
    var tableView = ListTableView()
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        self.title = "Favorites"
        self.view.backgroundColor = Color.Base.background
        
        self.setupTable()
        self.addBarButtonItems()
    }
    
    // MARK: Setup
    
    func addBarButtonItems() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addThing))
        self.navigationItem.setRightBarButton(addBarButtonItem, animated: true)
    }
    
    func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    // MARK: Action
    
    @objc func addThing() {
        // alert controller dialog for adding thing name + item name
        let alertController = UIAlertController(title: "Add Thing", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { action in
            guard let thingText = alertController.textFields?[0].text,
                let itemText = alertController.textFields?[1].text else { return }
            
            // add thing with item
            let thing = Thing(name: thingText)
            thing.addItem(name: itemText)
            self.viewModel.addThing(thing)
            
            // TODO: consider having the view model tell it when it should reload
            self.tableView.reloadData()
        }
        
        alertController.addTextFields("Name", "Favourite")
        alertController.addActions(cancelAction, addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentThingController(index: ThingIndex) {
        let thing = self.viewModel.thing(at: index)
        
        let controller = ThingController(thing: thing)
        
        self.addChild(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension ListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: self.tableView.reuseIdentifier)
        
        // retrieve thing and item
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

extension ListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentThingController(index: ThingIndex(indexPath.section, indexPath.row))
    }
}

