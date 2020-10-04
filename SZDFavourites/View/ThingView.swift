//
//  ThingView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ThingViewDelegate: class {
    func didEdit()
    func didDelete()
    func didEditItems()
}

class ThingView: UIView {
    
    weak var delegate: ThingViewDelegate?
    
    let nameLabel = UILabel()
    let itemLabel = UILabel()
    let editButton = UIButton()
    let deleteButton = UIButton()
    let editItemsButton = UIButton()
    
    init(thing: Thing) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.white.alpha(0.9)
        
        self.editButton.setTitle("Edit", for: .normal)
        self.editButton.setTitleColor(.systemBlue, for: .normal)
        self.deleteButton.setTitle("Delete", for: .normal)
        self.deleteButton.setTitleColor(.systemBlue, for: .normal)
        self.editItemsButton.setTitleColor(.systemBlue, for: .normal)
        self.editItemsButton.setTitle("Edit Items", for: .normal)
        
        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            return view
        }()
        
        self.addSubviews(stackView)
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.itemLabel)
        stackView.addArrangedSubview(self.editButton)
        stackView.addArrangedSubview(self.deleteButton)
        stackView.addArrangedSubview(self.editItemsButton)
        
        self.editButton.addTarget(self, action: #selector(pressEdit), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(pressDelete), for: .touchUpInside)
        self.editItemsButton.addTarget(self, action: #selector(pressEditItems), for: .touchUpInside)
        
        self.setText(thing: thing)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(thing: Thing) {
        self.nameLabel.text = "Favorite " + thing.name
        
        var itemString = ""
        thing.items.forEach { item in
            itemString += (itemString.isEmpty ? "" : ", ") + item.name
        }
        
        self.itemLabel.text = itemString
    }
    
    @objc func pressEdit() {
        self.delegate?.didEdit()
    }
    
    @objc func pressDelete() {
        self.delegate?.didDelete()
    }
    
    @objc func pressEditItems() {
        self.delegate?.didEditItems()
    }
}
