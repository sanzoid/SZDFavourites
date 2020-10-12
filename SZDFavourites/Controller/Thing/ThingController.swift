//
//  ThingController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ThingController: UIViewController {
    
    weak var dataSource: ThingControllerDataSource?
    weak var delegate: ThingControllerDelegate?
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        
    }
    
    func toggleEdit() {
        
    }
}

extension ThingController: ItemControllerDataSource {
    var numberOfItems: Int {
        return self.dataSource?.numberOfItems ?? 0
    }
    
    func dataForItem(at index: Int) -> ViewDataItem {
        return self.dataSource!.dataForItem(at: index)
    }
}

extension ThingController: ItemControllerDelegate {
    func selectItem(index: Int) {
        // TODO:
    }
    
    func addItem() {
        // TODO:
    }
    
    func removeItem(at index: Int) {
        self.delegate?.removeItem(at: index)
    }
    
    func moveItem(from index: Int, to newIndex: Int) {
        self.delegate?.moveItem(from: index, to: newIndex)
    }
}
