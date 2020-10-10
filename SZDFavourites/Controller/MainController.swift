//
//  MainController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit

class MainController: UIViewController {
    
    let model: Model
    let viewModel: ListViewModel
    let listController = ListController2()
    
    init(model: Model) {
        self.model = model
        self.viewModel = ListViewModel(model: model)
        
        super.init(nibName: nil, bundle: nil)
        
        self.listController.dataSource = self
        self.listController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.addChildDefault(viewController: self.listController)
        self.listController.view.constrainTo(view: self.view, on: .all)
        self.view.backgroundColor = Color.Base.background
    }
}

extension MainController: ListControllerDataSource2 {
    func numberOfGroups() -> Int {
        return self.viewModel.groupCount()
    }
    
    func numberOfThings(in group: Int) -> Int {
        return self.viewModel.thingCount(group: group)
    }
    
    func dataForThing(at thingIndex: Int, group groupIndex: Int) -> ListThingData {
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
    
}
