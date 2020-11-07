//
//  ThingBar.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ThingBar: UIView {
    // group picker
    private var groupPicker: TextPicker
    // edit/done  button
    private var editButton: UIButton
    
    init() {
        self.groupPicker = TextPicker()
        self.editButton = UIButton()
        
        super.init(frame: .zero)
        
        self.setup()
    }
    
    func setup() {
        self.backgroundColor = .darkGray
        self.clipsToBounds = true
        
        self.editButton.setTitle("Edit", for: .normal)
        self.editButton.setTitleColor(.white, for: .normal)
        
        self.addSubviews(groupPicker, editButton)
        groupPicker.constrainToHorizontal(of: self, axis: .leading, constant: 10)
        groupPicker.constrainToCenter(of: self, axis: .y, constant: 0)
        groupPicker.constrainToVertical(of: self, axis: .both, constant: 10)
        groupPicker.constrainToWidth(constant: 200)
        
        editButton.constrainToHorizontal(of: self, axis: .trailing, constant: 10)
        editButton.constrainToCenter(of: self, axis: .y, constant: 0)
        editButton.constrainToVertical(of: self, axis: .both, constant: 10)
        editButton.constrainToWidth(constant: 50)
        
        groupPicker.showTestOutline()
        editButton.showTestOutline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
