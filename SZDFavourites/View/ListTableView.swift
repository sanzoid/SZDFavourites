//
//  ListTableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ListTableView: UITableView {
    
    let reuseIdentifier = "ListTableView" 
    
    init() {
        super.init(frame: .zero, style: .grouped)
        
        self.separatorStyle = .none
        self.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
