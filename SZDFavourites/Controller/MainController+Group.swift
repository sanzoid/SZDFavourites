//
//  MainController+Group.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: GroupControllerDataSource {
    func dataForGroup(at index: Int) -> DataGroup {
        let group = self.viewModel.group(at: index)
        let data = DataGroup(name: group.name)
        return data
    }
}

extension MainController: GroupControllerDelegate {
    func selectGroup(at index: Int) {
        // TODO:
    }
    
    func addGroup() {
        // TODO:
    }
    
    func removeGroup(at index: Int) -> Bool {
        if let error = self.viewModel.remove(group: index) {
            return false 
        } else {
            return true
        }
    }
    
    func moveGroup(from index: Int, to newIndex: Int) {
        self.viewModel.move(group: index, to: index)
    }
}
