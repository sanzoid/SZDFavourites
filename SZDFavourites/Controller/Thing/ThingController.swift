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
    
    let groupField = TextPicker()
    let thingField = TextField()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.thingField.delegate = self
        
        self.view.backgroundColor = UIColor.black.alpha(0.1)
        
        // view init
        let containerView = UIView()
        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            view.distribution = .equalSpacing
            view.alignment = .fill
            return view
        }()
        
        // view hierarchy
        self.view.addSubviews(containerView)
        containerView.addSubviews(stackView)
        stackView.addArrangedSubview(groupField)
        stackView.addArrangedSubview(thingField)
        
        // view constraints
        containerView.constrainTo(view: self.view, on: .center)
        containerView.constrainToHeight(constant: 600)
        containerView.constrainToHorizontal(of: self.view, axis: .both, constant: 0)
        
        stackView.constrainTo(view: containerView, on: .horizontal, constant: 50)
        stackView.constrainToVertical(of: containerView, axis: .top, constant: 50)
        
        // view values
        containerView.backgroundColor = UIColor.white.alpha(0.6)
        groupField.label.text = "Group"
        thingField.textField.text = "Thing"
        groupField.backgroundColor = .cyan
        thingField.backgroundColor = .purple
    }
    
    func refresh() {
        if let thing = self.dataSource?.dataForThing() {
            self.thingField.setText(thing.name, placeholder: thing.name)
        }
    }
    
    func toggleEdit() {
        
    }
}

extension ThingController: ItemControllerDataSource {
    var numberOfItems: Int {
        return self.dataSource?.numberOfItems ?? 0
    }
    
    func dataForItem(at index: Int) -> ViewDataItem {
        return self.dataSource!.dataForItem(at: index)
    }
}

extension ThingController: ItemControllerDelegate {
    func selectItem(index: Int) {
        // TODO:
    }
    
    func addItem() {
        // TODO:
    }
    
    func removeItem(at index: Int) {
        self.delegate?.removeItem(at: index)
    }
    
    func moveItem(from index: Int, to newIndex: Int) {
        self.delegate?.moveItem(from: index, to: newIndex)
    }
}

extension ThingController: TextFieldDelegate {
    func didEndEditing(text: String?) {
        if let text = text, !text.isEmpty {
            self.delegate?.editThing(name: text)
        } else { // if empty, reset
            self.refresh()
        }
    }
}
