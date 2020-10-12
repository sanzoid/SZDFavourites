//
//  MainController+List.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: ListControllerDataSource2 {
    func numberOfGroups() -> Int {
        return self.viewModel.groupCount()
    }
    
    func numberOfThings(in group: Int) -> Int {
        return self.viewModel.thingCount(group: group)
    }
    
    func dataForThing(at thingIndex: Int, in groupIndex: Int) -> ListThingData {
        let thing = self.viewModel.thing(at: (groupIndex, thingIndex))
        let data = ListThingData(name: thing.name,
                                 topItemName: thing.topItem()?.name,
                                 topItemImage: thing.topItem()?.image)
        return data
    }
    
    func dataForGroup(at index: Int) -> ListGroupData {
        let group = self.viewModel.group(at: index)
        let data = ListGroupData(name: group.name)
        return data
    }
}

extension MainController: ListControllerDelegate2 {
    func move(from index: ThingIndex, to newIndex: ThingIndex) {
        self.viewModel.move(thing: index, to: newIndex)
    }
    
    func selectThing(at index: ThingIndex) {
        self.editThing(at: index)
    }
    
    func addThing() {
        self.presentEditThingController(isAdd: true)
    }
    
    func removeThing(at index: ThingIndex) {
        self.viewModel.remove(thing: index)
    }
}
