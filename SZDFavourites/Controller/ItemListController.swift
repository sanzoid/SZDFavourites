//
//  ItemListController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-03.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ItemListDataSource: class {
    var numberOfItems: Int? { get }
    func item(at index: Int) -> Item?
}

protocol ItemListDelegate: class {
    func didPressAddItem()
    func didPressEditItem(index: Int)
    func didMoveItem(from index: Int, to newIndex: Int)
    func didDeleteItem(at index: Int)
}

/**
   The **ItemListController** manages a thing's item list.

   - Outside: Set dataSource and delegate and implement methods to pass in data and handle actions.
   - Inside: Present views, handle user interactions, tell delegate to make updates.
*/
class ItemListController: UIViewController {
    
    weak var delegate: ItemListDelegate?
    weak var dataSource: ItemListDataSource?
    
    let tableView: ItemListTableView
    
    init() {
        self.tableView = ItemListTableView()
        
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
        return (self.dataSource?.numberOfItems ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.tableView.reuseIdentifier, for: indexPath)
        
        if tableView.isLastRow(indexPath: indexPath) {
            // add item cell
            cell.textLabel?.text = "+"
        } else {
            if let item = self.dataSource?.item(at: indexPath.row) {
                cell.textLabel?.text = item.name
            }
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
