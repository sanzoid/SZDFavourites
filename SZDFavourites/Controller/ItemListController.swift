//
//  ItemListController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-03.
//  Copyright © 2020 sandzapps. All rights reserved.
//

//  TODO: Consider having a dataSource so you don't have to pass in Thing
//  We already have a delegate, to pass actions back up to the parent, might as well also get data from the parent.

import UIKit

class ItemListViewModel {
    
    let thing: Thing
    
    init(thing: Thing) {
        self.thing = thing
    }
    
    func itemCount() -> Int {
        return self.thing.itemCount()
    }
    
    func item(at index: Int) -> Item {
        return self.thing[index]
    }
}

protocol ItemListDelegate: class {
    func didPressAddItem()
    func didPressEditItem(index: Int)
    func didMoveItem(from index: Int, to newIndex: Int)
    func didDeleteItem(at index: Int)
}

class ItemListController: UIViewController {
    
    weak var delegate: ItemListDelegate?
    
    let tableView: ItemListTableView
    let thing: Thing
    let viewModel: ItemListViewModel
    
    init(thing: Thing) {
        self.thing = thing
        
        self.tableView = ItemListTableView()
        self.viewModel = ItemListViewModel(thing: thing)
        
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.tableView.reuseIdentifier)
        
        self.view.backgroundColor = .blue
        self.tableView.backgroundColor = .cyan
        self.view.addSubviews(self.tableView)
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func setEditMode(_ isEdit: Bool) {
        self.tableView.setEditing(isEdit, animated: true)
    }
}

// TODO: move to SZDCommons
extension UITableView {
    func isLastRow(indexPath: IndexPath) -> Bool {
        return indexPath.row == self.numberOfRows(inSection: indexPath.section) - 1
    }
}

extension ItemListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.itemCount() + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier, for: indexPath)
        
        if tableView.isLastRow(indexPath: indexPath) {
            // add item cell
            cell.textLabel?.text = "+"
        } else {
            let item = self.viewModel.item(at: indexPath.row)
            cell.textLabel?.text = item.name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return !tableView.isLastRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !tableView.isLastRow(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

extension ItemListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isLastRow(indexPath: indexPath) {
            // add item
            self.delegate?.didPressAddItem()
        } else {
            // edit item
            self.delegate?.didPressEditItem(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.delegate?.didMoveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // TODO: Change add cell to a footer so we don't have to do all this last row logic
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        return tableView.isLastRow(indexPath: proposedDestinationIndexPath) ? sourceIndexPath : proposedDestinationIndexPath
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.didDeleteItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
