//
//  MainController+List.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: ListControllerDataSource {
    func numberOfGroups() -> Int {
        return self.viewModel.groupCount()
    }
    
    func numberOfThings(in group: Int) -> Int {
        return self.viewModel.thingCount(group: group)
    }
    
    func dataForThing(at thingIndex: Int, in groupIndex: Int) -> ViewDataThing {
        let thing = self.viewModel.thing(at: (groupIndex, thingIndex))
        return ViewDataThing(thing: thing)
    }
    
    func dataForGroupHeader(at index: Int) -> ViewDataGroup {
        let group = self.viewModel.group(at: index)
        return ViewDataGroup(group: group)
    }
}

extension MainController: ListControllerDelegate {
    func moveThing(from index: ThingIndex, to newIndex: ThingIndex) {
        self.viewModel.move(thing: index, to: newIndex)
    }
    
    func selectThing(at index: ThingIndex) {
//        self.editThing(at: index)
        self.presentThingController(at: index)
    }
    
    func addThing() {
        self.presentEditThingController(isAdd: true)
    }
    
    func removeThing(at index: ThingIndex) {
        self.viewModel.remove(thing: index)
    }
}
