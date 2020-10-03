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

protocol ThingControllerDelegate: class {
    func shouldEdit(thing: Thing)
    func shouldDelete(thing: Thing)
    func shouldAddItem(name: String, to thing: Thing)
    func shouldEditItem(at index: Int,for thing: Thing, with newName: String)
}

class ThingController: UIViewController {
    
    weak var delegate: ThingControllerDelegate?
    
    let thing: Thing
    let viewModel: ThingViewModel
    let thingView: ThingView
    
    let itemListController: ItemListController
    
    init(thing: Thing) {
        self.thing = thing
        self.viewModel = ThingViewModel(thing: thing)
        self.thingView = ThingView(thing: thing)
        self.itemListController = ItemListController(thing: thing)
        
        super.init(nibName: nil, bundle: nil)
        
        self.thingView.delegate = self
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
    
    @objc func close() {
        self.removeFromParentDefault()
    }
    
    func edit() {
        self.close()
        self.delegate?.shouldEdit(thing: self.thing)
    }
    
    func delete() {
        // delete - work out this communication
        self.delegate?.shouldDelete(thing: self.thing)
        self.close()
    }
    
    func addItem(name: String) {
        self.delegate?.shouldAddItem(name: name, to: self.thing)
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
                self.delegate?.shouldEditItem(at: index, for: self.thing, with: text)
                
                self.itemListController.refresh()
            }
            textFieldText = self.thing[index].name // FIXME: we should be accessing this a better way, possibly through the viewmodel if it's useful
        } else {
            title = "Add Item"
            actionTitle = "Add"
            actionBlock = { text in
                self.delegate?.shouldAddItem(name: text, to: self.thing)
                
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

extension ThingController: ThingViewDelegate {
    func didEdit() {
        self.edit()
    }
    
    func didDelete() {
        self.delete()
    }
    
    func didAddItem(name: String) {
        self.addItem(name: name)
        self.thingView.setText(thing: self.thing)
    }
}

extension ThingController: ItemListDelegate {
    func didPressAddItem() {
        self.editItem(isAdd: true)
    }
    
    func didPressEditItem(index: Int) {
        self.editItem(isAdd: false, index: index)
    }
}
