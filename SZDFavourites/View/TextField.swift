//
//  TextField.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-13.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A TextField with display and edit modes

import UIKit

protocol TextFieldDelegate: class {
    func didEndEditing(text: String?)
}

enum TextFieldMode {
    case display
    case edit
}

class TextField: UIView {
    
    weak var delegate: TextFieldDelegate?
    
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
        
        // textfield properties
        self.textField.delegate = self
        self.textField.returnKeyType = .done
    }
    
    func setMode(_ mode: TextFieldMode) {
        self.mode = mode 
    }
    
    func setText(_ text: String?, placeholder: String?) {
        self.textField.placeholder = placeholder
        self.textField.text = text
    }
}

extension TextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // dismiss keyboard on return
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didEndEditing(text: textField.text)
    }
}
