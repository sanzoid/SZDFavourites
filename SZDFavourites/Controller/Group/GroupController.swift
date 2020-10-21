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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
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
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        if let cellData = self.dataSource?.dataForGroup(for: self, at: indexPath.row) {
            cell.textLabel?.text = cellData.name
        }
        
        return cell
    }
}

extension GroupController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectGroup(for: self, at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
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
