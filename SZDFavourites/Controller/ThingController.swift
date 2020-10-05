//
//  ThingController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//
//  A controller for the Thing view
//  A user can view, edit, and delete their Thing

import UIKit
import SZDCommons

// TODO: ListController should know which Thing is being manipulated. ThingController does not need to know which Thing is being manipulated. It should simply just ask its parent for data and to perform actions. It only needs to know there is a Thing, but not exactly which. 
protocol ThingControllerDataSource: class {
    var numberOfItems: Int? { get }
    func name() -> ThingName?
    func item(at index: Int) -> Item?
}

protocol ThingControllerDelegate: class {
    func shouldEdit()
    func shouldDelete()
    func shouldAddItem(name: String)
    func shouldEditItem(at index: Int, with newName: String)
    func shouldMoveItem(from index: Int, to newIndex: Int)
    func shouldDeleteItem(at index: Int)
    func close()
}

/**
   The **ThingController** manages a thing.

   - Outside: Set dataSource and delegate and implement methods to pass in data and handle actions.
   - Inside: Present views, handle user interactions, tell delegate to make updates.
*/
class ThingController: UIViewController {
    
    weak var dataSource: ThingControllerDataSource?
    weak var delegate: ThingControllerDelegate?
    
    let thingView: ThingView
    
    let itemListController: ItemListController
    
    var itemListIsEditing: Bool = false
    
    init() {
        self.thingView = ThingView()
        self.itemListController = ItemListController()
        
        super.init(nibName: nil, bundle: nil)
        
        self.thingView.dataSource = self
        self.thingView.delegate = self
        self.itemListController.dataSource = self
        self.itemListController.delegate = self

        self.view.backgroundColor = UIColor.black.alpha(0.5)
        self.thingView.backgroundColor = .yellow
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillProportionally
            return stackView
        }()
        
        self.view.addSubviews(stackView)
        
        stackView.addArrangedSubview(self.itemListController.view)
        stackView.addArrangedSubview(self.thingView)
        
        stackView.constrainTo(view: self.view, on: .center)
        stackView.constrainToHeight(constant: 600)
        stackView.constrainToHorizontal(of: self.view, axis: .both, constant: 20)
        
        // tap background to dismiss
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(close))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        self.view.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // TODO: find a better way to make sure the initial stuff is all there 
        self.thingView.refresh()
    }
    
    func toggleEdit() {
        self.itemListIsEditing = !self.itemListIsEditing
        self.itemListController.setEditMode(self.itemListIsEditing)
    }
    
    @objc func close() {
        self.removeFromParentDefault()
    }
    
    func edit() {
        self.delegate?.shouldEdit()
    }
    
    func delete() {
        // delete - work out this communication
        self.delegate?.shouldDelete()
        self.close()
    }
    
    func moveItem(from index: Int, to newIndex: Int) {
        self.delegate?.shouldMoveItem(from: index, to: newIndex)
    }
    
    func addItem(name: String) {
        self.delegate?.shouldAddItem(name: name)
    }
    
    func deleteItem(at index: Int) {
        self.delegate?.shouldDeleteItem(at: index)
    }
    
    func editItem(isAdd: Bool, index: Int? = nil) {
        var title: String
        var actionTitle: String
        var actionBlock: (String) -> Void
        var textFieldText: String?

        if !isAdd, let index = index {
            title = "Edit Item"
            actionTitle = "OK"
            actionBlock = { text in
                self.delegate?.shouldEditItem(at: index, with: text)

                self.itemListController.refresh()
            }
            textFieldText = self.dataSource?.item(at: index)?.name
        } else {
            title = "Add Item"
            actionTitle = "Add"
            actionBlock = { text in
                self.delegate?.shouldAddItem(name: text)

                self.itemListController.refresh()
            }
        }

        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: actionTitle, style: .default) { action in
            guard let text = alertController.textFields?[0].text else { return }

            actionBlock(text)
        }

        alertController.addTextFields(("Item", textFieldText))
        alertController.addActions(cancelAction, addAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension ThingController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // limit only to the view with the gesture recognizer and not its subviews
        return touch.view == gestureRecognizer.view
    }
}

extension ThingController: ThingViewDataSource {
    var name: String? {
        return self.dataSource?.name()
    }
}

extension ThingController: ThingViewDelegate {
    func didEdit() {
        self.edit()
    }
    
    func didDelete() {
        self.delete()
    }
    
    func didEditItems() {
        self.toggleEdit()
    }
}

extension ThingController: ItemListDataSource {
    var numberOfItems: Int? {
        return self.dataSource?.numberOfItems
    }
    
    func item(at index: Int) -> Item? {
        return self.dataSource?.item(at: index)
    }
}

extension ThingController: ItemListDelegate {
    func didPressAddItem() {
        self.editItem(isAdd: true)
    }
    
    func didPressEditItem(index: Int) {
        self.editItem(isAdd: false, index: index)
    }
    
    func didMoveItem(from index: Int, to newIndex: Int) {
        self.moveItem(from: index, to: newIndex)
    }
    
    func didDeleteItem(at index: Int) {
        self.deleteItem(at: index)
    }
}
