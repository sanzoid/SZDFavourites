//
//  ItemController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ItemController: UIViewController {
    
    weak var dataSource: ItemControllerDataSource?
    weak var delegate: ItemControllerDelegate?
    var tableView: UITableView
    
    private var mode: ViewMode
        
    init(mode: ViewMode = .display) {
        self.mode = mode
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
        
        self.setMode(mode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubviews(self.tableView)
//        self.tableView.constrainTo(view: self.view, on: .all)
        self.tableView.constrainToHeight(constant: 300)
        
        self.tableView.backgroundColor = UIColor.yellow.alpha(0.2)
        self.tableView.allowsSelection = false
        self.tableView.bounces = false
        
        // enable drag
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.dragInteractionEnabled = true
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func setMode(_ mode: ViewMode) {
        self.mode = mode
        self.tableView.dragInteractionEnabled = mode == .edit
        
        // reload for cell mode
        self.tableView.reloadData()
    }
}

// MARK: UITableView

extension ItemController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ItemCell(style: .default, reuseIdentifier: "ItemCell")
        
        if let data = self.dataSource?.dataForItem(at: indexPath.row) {
            cell.setText(data.name)
            cell.delegate = self
            cell.tag = indexPath.row
            cell.setMode(self.mode)
        }
        
        return cell
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
}

extension ItemController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        self.delegate?.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
}

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

// MARK: TableFooterTextFieldDelegate

extension ItemController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.delegate?.addItem(name: text)
        footer.setText(nil, placeholder: "Add Item")
    }
}

// MARK: ItemCellDelegate

extension ItemController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String?) {
        // TODO: Where should we validate empty?
        guard let text = text, !text.isEmpty else { return }
        let index = itemCell.tag
        self.delegate?.editItem(at: index, with: text)
    }
}
