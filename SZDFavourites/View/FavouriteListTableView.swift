//
//  FavouriteListTableView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class FavouriteListTableView: UITableView {
    
    let reuseIdentifier = "FavouriteListTableView" 
    
    init() {
        super.init(frame: .zero, style: .plain)
        
        self.separatorStyle = .none
        self.bounces = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
