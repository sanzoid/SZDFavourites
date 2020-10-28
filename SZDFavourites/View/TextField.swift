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
    func didEndEditing(for textField: TextField, text: String)
}

class TextField: UIView {
    
    weak var delegate: TextFieldDelegate?
    
    private var mode: ViewMode
    private var textField = UITextField()
        
    init(mode: ViewMode = .display) {
        self.mode = mode
        
        super.init(frame: .zero)
        
        self.setup()
        
        self.setMode(mode)
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
    
    func setMode(_ mode: ViewMode) {
        self.mode = mode
        
        self.textField.isUserInteractionEnabled = mode == .edit
    }
    
    func setText(_ text: String?, placeholder: String?) {
        self.textField.placeholder = placeholder
        self.setText(text)
    }
    
    func setText(_ text: String?) {
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
        self.delegate?.didEndEditing(for: self, text: textField.text ?? "")
    }
}
