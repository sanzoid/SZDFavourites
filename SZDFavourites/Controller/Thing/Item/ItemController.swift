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
    
    init() {
        self.tableView = UITableView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
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
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func toggleEdit() {
        self.tableView.setEditing(!self.isEditing, animated: true)
    }
}

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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = TableFooterTextField(reuseIdentifier: "ItemControllerFooter")
        footer.delegate = self
        footer.setText(nil, placeholder: "Add Item")
        
        return footer
    }
}

extension ItemController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectItem(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.delegate?.moveItem(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.delegate?.removeItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

extension ItemController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.delegate?.addItem(name: text)
        footer.setText(nil, placeholder: "Add Item")
    }
}

extension ItemController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String?) {
        // TODO: Where should we validate empty?
        guard let text = text, !text.isEmpty else { return }
        let index = itemCell.tag
        self.delegate?.editItem(at: index, with: text)
    }
}
