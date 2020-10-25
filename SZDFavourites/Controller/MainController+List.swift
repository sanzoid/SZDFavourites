//
//  MainController+List.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

extension MainController: ListControllerDataSource {
    func numberOfGroups(for listController: ListController) -> Int {
        return self.viewModel.groupCount()
    }
    
    func numberOfThings(for listController: ListController, in group: Int) -> Int {
        return self.viewModel.thingCount(group: group)
    }
    
    func dataForThing(for listController: ListController, at thingIndex: Int, in groupIndex: Int) -> ViewDataThing {
        let thing = self.viewModel.thing(at: (groupIndex, thingIndex))
        return ViewDataThing(thing: thing)
    }
    
    func dataForGroupHeader(for listController: ListController, at index: Int) -> ViewDataGroup {
        let group = self.viewModel.group(at: index)
        return ViewDataGroup(group: group)
    }
}

extension MainController: ListControllerDelegate {
    func moveThing(for listController: ListController, from index: ThingIndex, to newIndex: ThingIndex) {
        self.viewModel.move(thing: index, to: newIndex)
    }
    
    func selectThing(for listController: ListController, at index: ThingIndex) {
        self.presentThingController(at: index, isAdd: false)
    }
    
    func removeThing(for listController: ListController, at index: ThingIndex) {
        self.viewModel.remove(thing: index)
    }
}
