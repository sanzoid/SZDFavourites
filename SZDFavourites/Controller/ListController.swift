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

/**
    The **ListController** is the main view for managing their favourites.
 
    - Outside: Pass in a Model object, intended to be the persisted model across app sessions.
    - Inside: Present views, handle user interactions, tell viewModel to update model.
 */
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
        let addGroupBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toggleEdit))
        
        self.navigationItem.setRightBarButtonItems([addBarButtonItem, addGroupBarButtonItem, editBarButtonItem], animated: true)
    }
    
    func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.constrainTo(view: self.view, on: .all)
        
        // TODO: register when a custom cell
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableView.reuseIdentifier)
        
        // register header
        self.tableView.register(ListTableHeader.self, forHeaderFooterViewReuseIdentifier: "ListHeader")
    }
    
    // MARK: Action
    
    @objc func toggleEdit() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @objc func addGroup() {
        self.presentEditGroupController(isAdd: true)
    }
    
    func presentEditGroupController(isAdd: Bool, group: Group? = nil) {
        var title: String
        var actionTitle: String
        var actionBlock: (String) -> Void
        var textFieldText: String?
        
        if !isAdd, let group = group {
            title = "Edit Group"
            actionTitle = "OK"
            actionBlock = { groupText in
                self.viewModel.edit(group: group.name, with: groupText)
                
                self.tableView.reloadData()
            }
            textFieldText = group.name
        } else {
            title = "Add Group"
            actionTitle = "Add"
            actionBlock = { groupText in
                self.viewModel.add(group: groupText)
                
                self.tableView.reloadData()
            }
        }
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: actionTitle, style: .default) { action in
            guard let text = alertController.textFields?[0].text else { return }
            
            actionBlock(text)
        }
        
        alertController.addTextFields(("Group", textFieldText))
        alertController.addActions(cancelAction, addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func addThing() {
        self.presentEditThingController(isAdd: true)
    }
    
    func editThing(_ thing: Thing) {
        self.presentEditThingController(isAdd: false, thing: thing)
    }
    
    // TODO: move this controller out to a class with delegates so we can change this up later
    func presentEditThingController(isAdd: Bool, thing: Thing? = nil) {
        var title: String
        var actionTitle: String
        var actionBlock: (String) -> Void
        var textFieldText: String?
        if !isAdd, let thing = thing {
            title = "Edit Thing"
            actionTitle = "OK"
            actionBlock = { thingText in
                self.viewModel.edit(thing: thing.name, with: thingText)
                
                self.tableView.reloadData()
            }
            textFieldText = thing.name
        } else {
            title = "Add Thing"
            actionTitle = "Add"
            actionBlock = { thingText in
                self.viewModel.add(thing: thingText)
                
                // TODO: consider having the view model tell it when it should reload
                self.tableView.reloadData()
            }
        }
        
        // alert controller dialog for adding thing name + item name
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: actionTitle, style: .default) { action in
            guard let thingText = alertController.textFields?[0].text else { return }
            
            actionBlock(thingText)
        }
        
        alertController.addTextFields(("Name", textFieldText))
        alertController.addActions(cancelAction, addAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentThingController(index: ThingIndex) {
        let thing = self.viewModel.thing(at: index)
        // TODO: probably don't need thing here
        self.viewModel.selectedThing = thing 
        
        let controller = ThingController()
        controller.dataSource = self
        controller.delegate = self
        
        self.addChild(controller)
        controller.view.frame = self.view.frame
        self.view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}

extension ListController: ThingControllerDataSource {
    var numberOfItems: Int? {
        return self.viewModel.selectedThing?.itemCount()
    }
    
    func name() -> ThingName? {
        return self.viewModel.selectedThing?.name
    }
    
    func item(at index: Int) -> Item? {
        return self.viewModel.selectedThing?.items[index]
    }
}

extension ListController: ThingControllerDelegate {
    func shouldEdit() {
        guard let thing = self.viewModel.selectedThing else { return }
        self.editThing(thing)
    }
    
    func shouldDelete() {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.remove(thing: thing)
        self.tableView.reloadData()
    }
    
    func shouldAddItem(name: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.add(item: name, to: thing.name)
    }
    
    func shouldEditItem(at index: Int, with newName: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.edit(item: index, for: thing.name, with: newName)
    }
    
    func shouldMoveItem(from index: Int, to newIndex: Int) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.move(item: index, for: thing.name, to: newIndex)
    }
    
    func shouldDeleteItem(at index: Int) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.remove(item: index, for: thing.name)
    }
    
    func close() {
        self.viewModel.selectedThing = nil
    }
}

extension ListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: use withIdentifier:for: when registering custom cell 
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: self.tableView.reuseIdentifier)
        
        // retrieve thing and item
        let index = ThingIndex(indexPath.section, indexPath.row)
        let thing = self.viewModel.thing(at: index) // FIXME:
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ListHeader") as! ListTableHeader
        
        view.section = section
        view.delegate = self
        view.nameLabel.text = self.viewModel.group(at: section).name
        
        return view
    }
}

extension ListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.presentThingController(index: ThingIndex(indexPath.section, indexPath.row))
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let index = ThingIndex(sourceIndexPath.section, sourceIndexPath.row)
        let newIndex = ThingIndex(destinationIndexPath.section, destinationIndexPath.row)
        self.viewModel.move(thing: index, to: newIndex)
    }
}

extension ListController: ListTableHeaderDelegate {
    func didPressEdit(section: Int) {
        self.presentEditGroupController(isAdd: false, group: self.viewModel.group(at: section))
    }
    
    func didPressRemove(section: Int) {
        self.viewModel.remove(group: section)
        self.tableView.reloadData()
    }
}
