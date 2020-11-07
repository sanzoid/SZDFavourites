//
//  ThingField.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ThingField: UIView {
    // label
    private var label: UILabel
    // textfield
    private var textField: TextField
    
    init() {
        self.label = UILabel()
        self.textField = TextField()
        super.init(frame: .zero)
        
        setup()
    }
    
    func setup() {
        self.addSubviews(label, textField)
        
        label.constrainToHorizontal(of: self, axis: .leading, constant: 10)
        label.constrainToVertical(of: self, axis: .top, constant: 10)
        
        textField.constrainToHorizontal(of: self, axis: .both, constant: 10)
        textField.constrainToCenter(of: self, axis: .x, constant: 0)
        textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10).isActive = true
        
        label.text = "Favourite"
        textField.setText("Thing")
        
        label.showTestOutline()
        textField.showTestOutline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
