//
//  ItemListTableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-03.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ItemListTableView: UITableView {
    
    let reuseIdentifier = "ListTableView"
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        self.separatorStyle = .none
        self.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
