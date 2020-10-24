//
//  ListController+TableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-24.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

extension ListController {
    func setupTable() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
    }
}

extension ListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource?.numberOfGroups(for: self) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfThings(for: self, in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        if let cellData = self.dataSource?.dataForThing(for: self, at: indexPath.row, in: indexPath.section) {
            cell.textLabel?.text = cellData.name
            cell.detailTextLabel?.text = cellData.top?.name ?? "-"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.dataSource?.dataForGroupHeader(for: self, at: section).name
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

extension ListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Make ThingIndex a struct
        let index = ThingIndex(indexPath.section, indexPath.row)
        self.delegate?.selectThing(for: self, at: index)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        let index = ThingIndex(sourceIndexPath.section, sourceIndexPath.row)
        let newIndex = ThingIndex(destinationIndexPath.section, destinationIndexPath.row)
        self.delegate?.moveThing(for: self, from: index, to: newIndex)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let index = ThingIndex(indexPath.section, indexPath.row)
            // TODO: may want to do validation first before deleting from table
            self.delegate?.removeThing(for: self, at: index)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: Drag & Drop

extension ListController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        return [dragItem]
    }
}

extension ListController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil { // from within the app
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {}
}
