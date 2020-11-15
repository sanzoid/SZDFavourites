//
//  ThingBar.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-11-07.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ThingBarDelegate: class {
    func didPressEdit(for thingBar: ThingBar)
}

class ThingBar: UIView {
    // group picker
    private var groupPicker: TextPicker
    // edit/done  button
    private var editButton: UIButton
    
    weak var delegate: ThingBarDelegate?
    var groupPickerDelegate: TextPickerDelegate? {
        didSet {
            self.groupPicker.delegate = self.groupPickerDelegate
        }
    }
    
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
        
        // H:|-groupPicker-editButton-|
        groupPicker.constrainToEdge(of: self, placement: .leadingToLeading, constant: 10)
        groupPicker.constrainToEdge(of: editButton, placement: .trailingToLeading, constant: 10)
        editButton.constrainToEdge(of: self, placement: .trailingToTrailing, constant: 10)
        // V:|-groupPicker-|
        groupPicker.constrainToEdge(of: self, placement: .topAndBottom, relativity: .lessThanOrEqual, constant: 10)
        groupPicker.constrainToCenter(of: self, axis: .y)
        // V:|-editButton-|
        editButton.constrainToEdge(of: self, placement: .topAndBottom, constant: 10, priority: .required)
        editButton.constrainToSize(constant: 50, dimension: .width)
        editButton.constrainToCenter(of: self, axis: .y)
        
        editButton.addTarget(self, action: #selector(didPressEdit), for: .touchUpInside)
        
        groupPicker.showTestOutline()
        editButton.showTestOutline()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressEdit() {
        self.delegate?.didPressEdit(for: self)
    }
}
