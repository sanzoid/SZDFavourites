//
//  MainController+Thing.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: ThingControllerDataSource {
    func numberOfGroups(for thingController: ThingController) -> Int {
        return self.viewModel.groupCount()
    }
    
    var numberOfItems: Int {
        return self.viewModel.itemCount(for: self.viewModel.selectedThing!.name)
    }
    
    func group(for thingController: ThingController) -> Int {
        let thing = self.viewModel.selectedThing!
        let index = self.viewModel.indexOfThing(name: thing.name)!
        return index.group
    }
    
    func dataForGroup(for thingController: ThingController, at index: Int) -> ViewDataGroup {
        let group = self.viewModel.group(at: index)
        return ViewDataGroup(group: group)
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
    func moveThing(from group: String, to newGroup: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.move(thing: thing.name, from: group, to: newGroup)
        self.listController.refresh()
    }
    
    func editThing() {
        // TODO: 
    }
    
    func editThing(name: String) {
        guard let thing = self.viewModel.selectedThing else { return }
        self.viewModel.edit(thing: thing.name, with: name)
        self.listController.refresh()
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
