//
//  ThingField.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit
import SZDCommons

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
        
        label.constrainToEdge(of: self, placement: .leadingToLeading, constant: 10)
        label.constrainToEdge(of: self, placement: .topToTop, constant: 10)
        
        textField.constrainToCenter(of: self, axis: .x)
        textField.constrainToEdge(of: self, placement: .leadingAndTrailing, constant: 10)
        textField.constrainToEdge(of: label, placement: .topToBottom, constant: 10)
        
        label.text = "Favourite"
        textField.setText("Thing")
        
        label.showTestOutline()
        textField.showTestOutline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
