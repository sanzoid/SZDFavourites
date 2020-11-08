//
//  ThingController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ThingController: UIViewController {
    
    weak var dataSource: ThingControllerDataSource?
    weak var delegate: ThingControllerDelegate?
    
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    private let groupField = TextPicker()
    private let thingField = TextField()
    private var thingBar = ThingBar()
    private var thingField2 = ThingField()
    let itemController = ItemController()
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.thingField.delegate = self
        self.groupField.dataSource = self
        self.groupField.delegate = self
        self.itemController.dataSource = self
        self.itemController.delegate = self 
        
        self.view.backgroundColor = .clear
        self.deleteButton.setTitle("Delete", for: .normal)
        self.deleteButton.setTitleColor(.white, for: .normal)
        self.deleteButton.backgroundColor = .red
        self.editButton.backgroundColor = .cyan
        
        // view init
        let containerView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.white.alpha(1)
            view.layer.cornerRadius = 10
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOpacity = 0.7
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 5
            return view
        }()
        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.distribution = .equalSpacing
            view.alignment = .fill
            return view
        }()
        
        // view hierarchy
        self.view.addSubviews(containerView)
        containerView.addSubviews(self.thingBar)
        
        containerView.addSubviews(stackView)
        stackView.addArrangedSubview(thingField2)
//        stackView.addArrangedSubview(self.editButton)
//        stackView.addArrangedSubview(self.groupField)
//        stackView.addArrangedSubview(self.thingField)
//        stackView.addArrangedSubview(self.itemController.tableView)
//        stackView.addArrangedSubview(self.deleteButton)
        
        // view constraints
        containerView.constrainToSize(constant: 600)
        containerView.constrainToEdge(of: self.view, placement: .leadingAndTrailing, constant: 20)
        containerView.constrainToCenter(of: self.view, axis: .both, constant: 0, relativity: .equal, priority: .required)
        
        thingBar.constrainToEdge(of: containerView, placement: .topToTop, constant: 0, priority: .required)
        thingBar.constrainToEdge(of: containerView, placement: .leadingAndTrailing, constant: 0, priority: .required)
        thingBar.constrainToSize(constant: 50, dimension: .height, priority: .defaultHigh)
        
        stackView.constrainToEdge(of: thingBar, placement: .topToBottom, constant: 10)
        stackView.constrainToEdge(of: containerView, placement: .leadingAndTrailing, constant: 10)
        
        // actions
        self.editButton.addTarget(self, action: #selector(pressEditButton), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(pressDeleteButton), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pressBackground))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
        self.setEdit(false)
        
//        self.view.showTestOutline()
//        containerView.showTestOutline()
        stackView.showTestOutline()
        groupField.showTestOutline()
        thingField.showTestOutline()
    }
    
    func refresh() {
        if let groupIndex = self.dataSource?.group(for: self) {
            self.groupField.setSelected(in: 0, row: groupIndex)
        }
        if let thing = self.dataSource?.dataForThing(for: self) {
            self.thingField.setText(thing.name, placeholder: thing.name)
        }
    }
    
    func setEdit(_ isEditing: Bool) {
        self.isEditing = isEditing
        self.editButton.setTitle(isEditing ? "Done" : "Edit", for: .normal)
        self.groupField.setMode(isEditing ? .edit : .display)
        self.thingField.setMode(isEditing ? .edit : .display)
        self.itemController.setMode(isEditing ? .edit : .display)
        self.deleteButton.isHidden = !isEditing
    }
    
    private func toggleEdit() {
        self.isEditing = !self.isEditing
        self.setEdit(self.isEditing)
    }
    
    @objc private func pressEditButton() {
        self.toggleEdit()
    }
    
    @objc private func pressDeleteButton() {
        self.delegate?.removeThing(for: self)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func pressBackground() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.delegate?.close(for: self)
    }
}

// MARK: UI DataSource & Delegate

extension ThingController: TextFieldDelegate {
    func didEndEditing(for textField: TextField, text: String) {
        if let error = self.delegate?.editThing(for: self, name: text) {
            error.present(on: self)
            self.refresh()
        }
    }
}

extension ThingController: TextPickerDataSource {
    func numberOfComponents(for textPicker: TextPicker) -> Int {
        return 1
    }
    
    func numberOfRows(for textPicker: TextPicker, in component: Int) -> Int {
        return self.dataSource?.numberOfGroups(for: self) ?? 0
    }
    
    func option(for textPicker: TextPicker, in component: Int, at row: Int) -> String {
        if let group = self.dataSource?.dataForGroup(for: self, at: row) {
            return group.name
        }
        return ""
    }
}

extension ThingController: TextPickerDelegate {
    func didEndEditing(for textPicker: TextPicker, oldText: String, text: String) {
        guard oldText != text else { return }
        self.delegate?.moveThing(for: self, from: oldText, to: text)
    }
}

extension ThingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}
