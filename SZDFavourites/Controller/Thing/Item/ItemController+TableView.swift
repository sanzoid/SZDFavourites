//
//  ItemController+TableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-21.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension ItemController {
    func setupTable() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
        self.tableView.estimatedRowHeight = 50
        
        self.tableView.allowsSelection = false
        self.tableView.backgroundColor = UIColor.yellow.alpha(0.2)
        self.tableView.bounces = false
    }
}

extension ItemController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems(for: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        
        if let data = self.dataSource?.dataForItem(for: self, at: indexPath.row) {
            cell.setText(data.name)
            cell.delegate = self
            cell.tag = indexPath.row
            cell.setMode(self.mode)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.mode == .edit
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard self.mode == .edit else { return nil }
        
        let footer = TableFooterTextField(reuseIdentifier: "ItemControllerFooter")
        footer.delegate = self
        footer.setText(nil, placeholder: "Add Item")
        footer.setMode(self.mode)
        return footer
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return self.mode == .edit
    }
}

extension ItemController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.removeItem(for: self, at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        self.delegate?.moveItem(for: self, from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

// MARK: Drag & Drop

extension ItemController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
}

extension ItemController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil { // from within the app
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}
