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
        self.tableView.constrainToEdge(of: self.view, placement: .all, withinSafeArea: false)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
}

extension GroupController: TableFooterTextFieldDelegate {
    func didFinishEditing(footer: TableFooterTextField, text: String) {
        guard !text.isEmpty else { return }
        if let error = self.delegate?.addGroup(for: self, name: text) {
            error.present(on: self)
        }
        footer.setText(nil)
    }
}

extension GroupController: GroupCellDelegate {
    func didEndEditing(for cell: GroupCell, text: String) {
        if let error = self.delegate?.editGroup(for: self, at: cell.tag, with: text) {
            error.present(on: self)
            self.refresh()
        }
    }
}
