//
//  TextPicker.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-13.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A TextPicker is a textField with a picker upon interaction

import UIKit

protocol TextPickerDataSource: class {
    func numberOfComponents(for textPicker: TextPicker) -> Int
    func numberOfRows(for textPicker: TextPicker, in component: Int) -> Int
    func option(for textPicker: TextPicker, in component: Int, at row: Int) -> String
}

protocol TextPickerDelegate: class {
    func didEndEditing(for textPicker: TextPicker, oldText: String, text: String)
}

class TextPicker: UIView {
    
    weak var dataSource: TextPickerDataSource?
    weak var delegate: TextPickerDelegate?
    
    private var mode: ViewMode
    private var textField = UITextField()
    private var picker = UIPickerView()
    private var oldText: String?
    
    private var isEditing: Bool = false
    
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
        
        self.textField.constrainToEdge(of: self, placement: .all)
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        self.textField.inputView = self.picker
        self.textField.tintColor = .clear
        self.textField.delegate = self
        
        // pickerview done
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(pickerDone))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        self.textField.inputAccessoryView = toolbar
    }
    
    @objc func pickerDone() {
        self.textField.resignFirstResponder()
    }
    
    func setMode(_ mode: ViewMode) {
        self.mode = mode
        self.textField.isUserInteractionEnabled = mode == .edit
    }
    
    func setSelected(in component: Int, row: Int) {
        if let text = self.dataSource?.option(for: self, in: component, at: row) {
            self.textField.text = text
            self.picker.selectRow(row, inComponent: component, animated: true)
        }
    }
}

extension TextPicker: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.oldText = textField.text
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.didEndEditing(for: self, oldText: self.oldText ?? "", text: textField.text ?? "")
    }
}

extension TextPicker: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataSource?.numberOfComponents(for: self) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource?.numberOfRows(for: self, in: component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource?.option(for: self, in: component, at: row) ?? ""
    }
}

extension TextPicker: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let string = self.dataSource?.option(for: self, in: component, at: row) {
            self.textField.text = string
        }
    }
}
