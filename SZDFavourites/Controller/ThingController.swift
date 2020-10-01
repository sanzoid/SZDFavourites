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

protocol ThingControllerDelegate: class {
    func shouldEdit(thing: Thing)
    func shouldDelete(thing: Thing)
    func shouldAddItem(name: String, to thing: Thing)
}

class ThingController: UIViewController {
    
    weak var delegate: ThingControllerDelegate?
    
    let thing: Thing
    let viewModel: ThingViewModel
    let thingView: ThingView
    
    init(thing: Thing) {
        self.thing = thing
        self.viewModel = ThingViewModel(thing: thing)
        self.thingView = ThingView(thing: thing)
        
        super.init(nibName: nil, bundle: nil)
        
        self.thingView.delegate = self

        self.view.backgroundColor = UIColor.black.alpha(0.5)
        
        self.view.addSubviews(self.thingView)
        self.thingView.constrainToHeight(constant: 300)
        self.thingView.constrainToHorizontal(of: self.view, axis: .both, constant: 20)
        self.thingView.constrainTo(view: self.view, on: .center)
        
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
