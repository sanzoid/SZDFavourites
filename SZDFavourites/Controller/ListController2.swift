//
//  ListController2.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-09.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ListTableGroupHeader2 {
    // view for a list table group header
}

class ListCell: UITableViewCell {
    // view for a list table thing cell
}

struct ListThingData {
    var name: String
    var topItemName: String?
    var topItemImage: UIImage?
}

struct ListGroupData {
    var name: String
}

protocol ListControllerDataSource2: class {
    func numberOfGroups() -> Int
    func numberOfThings(in group: Int) -> Int
    func dataForThing(at thingIndex: Int, in groupIndex: Int) -> ListThingData
    func dataForGroup(at index: Int) -> ListGroupData
}

protocol ListControllerDelegate2: class {
    func move(from index: ThingIndex, to newIndex: ThingIndex)
    func selectThing(at index: ThingIndex)
    func addThing()
    func removeThing(at index: ThingIndex)
}

class ListController2: UIViewController {
    
    weak var dataSource: ListControllerDataSource2?
    weak var delegate: ListControllerDelegate2?
    var tableView: UITableView
    
    init() {
        self.tableView = ListTableView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // setup
    func setup() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubviews(self.tableView)
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func toggleEdit() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    // actions
}

extension ListController2: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfThings(in: section) ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfGroups() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        if let cellData = self.dataSource?.dataForThing(at: indexPath.row, in: indexPath.section) {
            cell.textLabel?.text = cellData.name
            cell.detailTextLabel?.text = cellData.topItemName ?? "-"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource?.dataForGroup(at: section).name
    }
}

extension ListController2: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Make ThingIndex a struct
        let index = ThingIndex(indexPath.section, indexPath.row)
        self.delegate?.selectThing(at: index)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let index = ThingIndex(sourceIndexPath.section, sourceIndexPath.row)
        let newIndex = ThingIndex(destinationIndexPath.section, destinationIndexPath.row)
        self.delegate?.move(from: index, to: newIndex)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = ThingIndex(indexPath.section, indexPath.row)
            // TODO: may want to do validation first before deleting from table 
            self.delegate?.removeThing(at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
