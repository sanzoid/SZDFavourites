//
//  MainController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit

class MainController: UIViewController {
    
    let model: Model
    let viewModel: ListViewModel
    let listController = ListController2()
    
    init(model: Model) {
        self.model = model
        self.viewModel = ListViewModel(model: model)
        
        super.init(nibName: nil, bundle: nil)
        
        self.listController.dataSource = self
        self.listController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.addChildDefault(viewController: self.listController)
        self.listController.view.constrainTo(view: self.view, on: .all)
        self.view.backgroundColor = Color.Base.background
        
        self.addBarButtonItems()
    }
    
    func addBarButtonItems() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddThing))
        let addGroupBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressAddGroup))
        let editBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pressEdit))
        self.navigationItem.setRightBarButtonItems([addBarButtonItem, addGroupBarButtonItem, editBarButtonItem], animated: true)
    }
    
    @objc func pressAddGroup() {
        self.presentEditGroupController(isAdd: true)
    }
    
    @objc func pressAddThing() {
        self.presentEditThingController(isAdd: true)
    }
    
    @objc func pressEdit() {
        self.listController.toggleEdit()
    }
    
    func editThing(at index: ThingIndex) {
        let thing = self.model.thing(at: index)
        self.presentEditThingController(isAdd: false, thing: thing)
    }
}

extension MainController: ListControllerDataSource2 {
    func numberOfGroups() -> Int {
        return self.viewModel.groupCount()
    }
    
    func numberOfThings(in group: Int) -> Int {
        return self.viewModel.thingCount(group: group)
    }
    
    func dataForThing(at thingIndex: Int, in groupIndex: Int) -> ListThingData {
        let thing = self.viewModel.thing(at: (groupIndex, thingIndex))
        let data = ListThingData(name: thing.name,
                                 topItemName: thing.topItem()?.name,
                                 topItemImage: thing.topItem()?.image)
        return data
    }
    
    func dataForGroup(at index: Int) -> ListGroupData {
        let group = self.viewModel.group(at: index)
        let data = ListGroupData(name: group.name)
        return data 
    }
}

extension MainController: ListControllerDelegate2 {
    func move(from index: ThingIndex, to newIndex: ThingIndex) {
        self.viewModel.move(thing: index, to: newIndex)
    }
    
    func selectThing(at index: ThingIndex) {
        self.editThing(at: index)
    }
    
    func addThing() {
    }
    
    func removeThing(at index: ThingIndex) {
        self.viewModel.remove(thing: index)
    }
}

extension MainController {
    // MARK: Add Group Controller
    
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
                self.listController.refresh()
            }
            textFieldText = group.name
        } else {
            title = "Add Group"
            actionTitle = "Add"
            actionBlock = { groupText in
                self.viewModel.add(group: groupText)
                self.listController.refresh()
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
    
    // MARK: Add Thing Controller
    
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
                self.listController.refresh()
            }
            textFieldText = thing.name
        } else {
            title = "Add Thing"
            actionTitle = "Add"
            actionBlock = { thingText in
                self.viewModel.add(thing: thingText)
                self.listController.refresh()
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
}
