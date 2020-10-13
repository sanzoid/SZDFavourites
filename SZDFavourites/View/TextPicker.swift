//
//  TextPicker.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-13.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A TextPicker is a text label with a picker upon interaction

import UIKit

protocol TextPickerDelegate {
    
}

enum TextPickerMode {
    case display
    case edit
}

class TextPicker: UIView {
    
    var mode: TextPickerMode
    var label = UILabel()
    
    init(mode: TextPickerMode = .display) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubviews(self.label)
        
        self.label.constrainToHeight(constant: 50)
        self.label.constrainTo(view: self, on: .all)
    }
    
    func setMode(_ mode: TextPickerMode) {
        self.mode = mode
    }
}
