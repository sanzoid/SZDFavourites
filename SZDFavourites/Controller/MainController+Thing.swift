//
//  MainController+Thing.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: ThingControllerDataSource {
    var numberOfItems: Int {
        return self.viewModel.itemCount(for: self.viewModel.selectedThing!.name)
    }
    
    func dataForThing() -> ViewDataThing {
        let thing = self.viewModel.selectedThing!
        return ViewDataThing(thing: thing)
    }
    
    func dataForItem(at index: Int) -> ViewDataItem {
        let item = self.viewModel.selectedThing!.item(at: index)
        return ViewDataItem(item: item)
    }
}

extension MainController: ThingControllerDelegate {
    func editThing() {
        // TODO: 
    }
    
    func removeThing() {
        // TODO:
    }
    
    func addItem(name: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.add(item: name, to: thing.name)
    }
    
    func editItem(at index: Int, with newName: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.edit(item: index, for: thing.name, with: newName)
    }
    
    func moveItem(from index: Int, to newIndex: Int) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.move(item: index, for: thing.name, to: newIndex)
    }
    
    func removeItem(at index: Int) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.remove(item: index, for: thing.name)
    }
    
    func close() {
        
    }
}
