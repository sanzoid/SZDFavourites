//
//  TextField.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-13.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A TextField with display and edit modes

import UIKit

protocol TextFieldDelegate {
    
}

enum TextFieldMode {
    case display
    case edit
}

class TextField: UIView {
    
    var mode: TextFieldMode
    var textField = UITextField()
    
    init(mode: TextFieldMode = .display) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.addSubviews(self.textField)
        
        self.textField.constrainToHeight(constant: 50)
        self.textField.constrainTo(view: self, on: .all)
    }
    
    func setMode(_ mode: TextFieldMode) {
        self.mode = mode 
    }
}
