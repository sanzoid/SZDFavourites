//
//  ItemCell.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-19.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ItemCellDelegate: class {
    func didEndEditing(for itemCell: ItemCell, text: String?)
}

class ItemCell: UITableViewCell {
    
    weak var delegate: ItemCellDelegate?
    private let textField = TextField()
    private var mode: ViewMode = .display
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {        
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        self.textField.delegate = self
        
        self.contentView.addSubviews(self.textField)
        self.textField.constrainTo(view: self, on: .all)
        
        self.setMode(.display)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String?) {
        self.textField.setText(text, placeholder: text)
    }
    
    func setMode(_ mode: ViewMode) {
        self.mode = mode
        self.textField.setMode(mode)
    }
}

extension ItemCell: TextFieldDelegate {
    func didEndEditing(for textField: TextField, text: String?) {
        self.delegate?.didEndEditing(for: self, text: text)
    }
}
