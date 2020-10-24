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
        
        // table 
        self.setupTable()
        self.view.addSubviews(self.tableView)
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
}

extension GroupController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String?) {
        guard let text = text?.nonEmpty() else { return }
        self.delegate?.addGroup(for: self, name: text)
    }
}

extension GroupController: ItemCellDelegate {
    func didEndEditing(for itemCell: ItemCell, text: String?) {
        guard let text = text?.nonEmpty() else { return }
        self.delegate?.editGroup(for: self, at: itemCell.tag, with: text)
    }
}
