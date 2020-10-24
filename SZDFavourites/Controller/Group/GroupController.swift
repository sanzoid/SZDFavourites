//
//  GroupController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class GroupController: UIViewController {
    
    weak var dataSource: GroupControllerDataSource?
    weak var delegate: GroupControllerDelegate?
    let tableView: UITableView
    
    init() {
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.title = "Categories"
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
        
        self.tableView.allowsSelection = false
        
        self.view.addSubviews(self.tableView)
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func toggleEdit() {
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
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
        let cell = ItemCell(style: .default, reuseIdentifier: "GroupItemCell")
        
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
            if self.delegate?.removeGroup(for: self, at: indexPath.row) ?? false {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

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

extension GroupController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.delegate?.addGroup(for: self, name: text)
    }
}

extension GroupController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.delegate?.editGroup(for: self, at: itemCell.tag, with: text)
    }
}
