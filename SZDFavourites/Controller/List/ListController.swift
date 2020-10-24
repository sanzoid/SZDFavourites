//
//  ListController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-09.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ListController: UIViewController {
    
    weak var dataSource: ListControllerDataSource?
    weak var delegate: ListControllerDelegate?
    let tableView: UITableView
    
    init() {
        self.tableView = ListTableView()
        
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.setupTable()
        self.view.addSubviews(self.tableView)
        self.tableView.constrainTo(view: self.view, on: .all)
    }
    
    func refresh() {
        self.tableView.reloadData()
    }
    
    func toggleEdit() {
        self.isEditing = !self.isEditing
    }
}
