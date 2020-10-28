//
//  TableFooterTextField.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-19.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol TableFooterTextFieldDelegate: class {
    func didFinishEditing(footer: TableFooterTextField, text: String)
}

class TableFooterTextField: UITableViewHeaderFooterView {
    
    weak var delegate: TableFooterTextFieldDelegate?
    private var textField = TextField()
    private var mode: ViewMode = .display
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.addSubviews(self.textField)
        self.textField.constrainTo(view: self, on: .all, constant: 0)
        self.textField.delegate = self
        
        self.setMode(.display)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMode(_ mode: ViewMode) {
        self.mode = mode
        self.textField.setMode(mode)
    }
    
    func setText(_ text: String?, placeholder: String?) {
        self.textField.setText(text, placeholder: placeholder)
    }
}

extension TableFooterTextField: TextFieldDelegate {
    func didEndEditing(for textField: TextField, text: String) {
        self.delegate?.didFinishEditing(footer: self, text: text)
    }
}
