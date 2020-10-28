//
//  MainController+Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: GroupControllerDataSource {
    func numberOfGroups(for groupController: GroupController) -> Int {
        return self.viewModel.groupCount()
    }
    
    func dataForGroup(for groupController: GroupController, at index: Int) -> ViewDataGroup {
        let group = self.viewModel.group(at: index)
        let data = ViewDataGroup(group: group)
        return data
    }
}

extension MainController: GroupControllerDelegate {
    func addGroup(for groupController: GroupController, name: String) -> ErrorMessage? {
        if let error = self.viewModel.add(group: name) {
            return ErrorMessage(title: error.title, message: error.message)
        }
        self.groupController?.refresh()
        self.listController.refresh()
        return nil
    }
    
    func removeGroup(for groupController: GroupController, at index: Int) -> ErrorMessage? {
        if let error = self.viewModel.remove(group: index) {
            return ErrorMessage(title: error.title, message: error.message)
        }
        self.listController.refresh()
        return nil
    }
    
    func moveGroup(for groupController: GroupController, from index: Int, to newIndex: Int) {
        self.viewModel.move(group: index, to: newIndex)
        self.listController.refresh()
    }
    
    func editGroup(for groupController: GroupController, at index: Int, with newName: String) -> ErrorMessage? {
        if let error = self.viewModel.edit(group: index, with: newName) {
            return ErrorMessage(title: error.title, message: error.message)
        }
        self.groupController?.refresh()
        self.listController.refresh()
        return nil
    }
}
