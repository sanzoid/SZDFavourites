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
    private(set) var mode: ViewMode
    let tableView: UITableView
        
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
        self.setupTable()
        
        self.view.addSubviews(self.tableView)
        self.tableView.constrainToSize(constant: 300, dimension: .height)
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

// MARK: UI Delegate

extension ItemController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String) {
        self.delegate?.addItem(for: self, name: text)
        footer.setText(nil)
    }
}

extension ItemController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String) {
        let index = itemCell.tag
        self.delegate?.editItem(for: self, at: index, with: text)
    }
}
