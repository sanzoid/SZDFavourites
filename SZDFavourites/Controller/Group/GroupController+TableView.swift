//
//  GroupController+TableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-24.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension GroupController {
    func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
        
        self.tableView.allowsSelection = false
    }
}

extension GroupController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfGroups(for: self) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = GroupCell(style: .default, reuseIdentifier: "GroupCell")
        
        if let data = self.dataSource?.dataForGroup(for: self, at: indexPath.row) {
            cell.setText(data.name)
            cell.delegate = self
            cell.tag = indexPath.row
            cell.setMode(.edit)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = TableFooterTextField(reuseIdentifier: "GroupControllerFooter")
        footer.delegate = self
        footer.setText(nil, placeholder: "Add Group")
        footer.setMode(.edit)
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension GroupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        self.delegate?.moveGroup(for: self, from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let error = self.delegate?.removeGroup(for: self, at: indexPath.row) {
                error.present(on: self)
            } else {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: Drag & Drop

extension GroupController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
}

extension GroupController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil { // from within the app
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}
