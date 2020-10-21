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
    func selectGroup(for groupController: GroupController, at index: Int) {
        // TODO:
    }
    
    func addGroup(for groupController: GroupController) {
        // TODO:
    }
    
    func removeGroup(for groupController: GroupController, at index: Int) -> Bool {
        if let error = self.viewModel.remove(group: index) {
            return false
        } else {
            return true
        }
    }
    
    func moveGroup(for groupController: GroupController, from index: Int, to newIndex: Int) {
        self.viewModel.move(group: index, to: index)
    }
}
