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
    private(set) var tableView: UITableView
    private(set) var mode: ViewMode
        
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

// MARK: TableFooterTextFieldDelegate
extension ItemController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.delegate?.addItem(for: self, name: text)
        footer.setText(nil, placeholder: "Add Item")
    }
}

// MARK: ItemCellDelegate
extension ItemController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String?) {
        // TODO: Where should we validate empty?
        guard let text = text, !text.isEmpty else { return }
        let index = itemCell.tag
        self.delegate?.editItem(for: self, at: index, with: text)
    }
}
