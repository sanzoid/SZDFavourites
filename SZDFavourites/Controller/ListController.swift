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
    
    let model: Model
    let viewModel: ListViewModel
    var tableView: ListTableView
    
    init(model: Model) {
        self.model = model
        self.viewModel = ListViewModel(model: model)
        
        self.tableView = ListTableView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        self.presentEditThingController(isAdd: true)
    }
    
    func editThing(_ thing: Thing) {
        self.presentEditThingController(isAdd: false, thing: thing)
    }
    
    func presentEditThingController(isAdd: Bool, thing: Thing? = nil) {
        var title: String
        var actionTitle: String
        var actionBlock: (String, String) -> Void
        var textFieldPlaceholder: (thing: String?, item: String?)
        if !isAdd, let thing = thing {
            title = "Edit Thing"
            actionTitle = "Edit"
            actionBlock = { thingText, itemText in
                self.viewModel.edit(thing: thing, with: thingText, topItemName: itemText)
                
                self.tableView.reloadData()
            }
            textFieldPlaceholder = (thing.name, thing.topItem()?.name)
        } else {
            title = "Add Thing"
            actionTitle = "Add"
            actionBlock = { thingText, itemText in
                // add thing with item
                let thing = Thing(name: thingText)
                if !itemText.isEmpty {
                    thing.addItem(name: itemText)
                }
                self.viewModel.add(thing: thing)
                
                // TODO: consider having the view model tell it when it should reload
                self.tableView.reloadData()
            }
        }
        
        // alert controller dialog for adding thing name + item name
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: actionTitle, style: .default) { action in
            guard let thingText = alertController.textFields?[0].text,
                let itemText = alertController.textFields?[1].text else { return }
            
            actionBlock(thingText, itemText)
        }
        
        alertController.addTextFields(("Name", textFieldPlaceholder.thing), ("Favourite", textFieldPlaceholder.item))
        alertController.addActions(cancelAction, addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentThingController(index: ThingIndex) {
        let thing = self.viewModel.thing(at: index)! // FIXME:
        
        let controller = ThingController(thing: thing)
        controller.delegate = self
        
        self.addChild(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension ListController: ThingControllerDelegate {
    func shouldEdit(thing: Thing) {
        self.editThing(thing)
    }
    
    func shouldDelete(thing: Thing) {
        self.viewModel.remove(thing: thing)
        self.tableView.reloadData()
    }
}

extension ListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: self.tableView.reuseIdentifier)
        
        // retrieve thing and item
        let index = ThingIndex(indexPath.section, indexPath.row)
        let thing = self.viewModel.thing(at: index)! // FIXME:
        let item = thing.topItem()
        
        cell.textLabel?.text = thing.name
        cell.detailTextLabel?.text = item?.name ?? "-"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.groupCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.thingCount(group: section)
    }
}

extension ListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentThingController(index: ThingIndex(indexPath.section, indexPath.row))
    }
}
