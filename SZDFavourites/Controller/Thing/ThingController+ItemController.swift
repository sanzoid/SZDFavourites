//
//  ThingController+ItemController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-21.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension ThingController: ItemControllerDataSource {
    func numberOfItems(for itemController: ItemController) -> Int {
        return self.dataSource?.numberOfItems(for: self) ?? 0
    }
    
    func dataForItem(for itemController: ItemController, at index: Int) -> ViewDataItem {
        return self.dataSource!.dataForItem(for: self, at: index)
    }
}

extension ThingController: ItemControllerDelegate {
    func addItem(for itemController: ItemController, name: String) {
        self.delegate?.addItem(for: self, name: name)
        self.itemController.refresh()
    }
    
    func removeItem(for itemController: ItemController, at index: Int) {
        self.delegate?.removeItem(for: self, at: index)
    }
    
    func moveItem(for itemController: ItemController, from index: Int, to newIndex: Int) {
        self.delegate?.moveItem(for: self, from: index, to: newIndex)
    }
    
    func editItem(for itemController: ItemController, at index: Int, with newName: String) {
        self.delegate?.editItem(for: self, at: index, with: newName)
    }
}
