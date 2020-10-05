//
//  ThingView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ThingViewDataSource: class {
    var name: String? { get }
}

protocol ThingViewDelegate: class {
    func didEdit()
    func didDelete()
    func didEditItems()
}

class ThingView: UIView {
    
    weak var dataSource: ThingViewDataSource?
    weak var delegate: ThingViewDelegate?
    
    private let nameLabel = UILabel()
//    let itemLabel = UILabel()
    private let editButton = UIButton()
    private let deleteButton = UIButton()
    private let editItemsButton = UIButton()
    
    init() {
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
//        stackView.addArrangedSubview(self.itemLabel)
        stackView.addArrangedSubview(self.editButton)
        stackView.addArrangedSubview(self.deleteButton)
        stackView.addArrangedSubview(self.editItemsButton)
        
        self.editButton.addTarget(self, action: #selector(pressEdit), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(pressDelete), for: .touchUpInside)
        self.editItemsButton.addTarget(self, action: #selector(pressEditItems), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refresh() {
        guard let name = self.dataSource?.name else { return }
        self.nameLabel.text = "Favorite " + name
    }
    
    @objc private func pressEdit() {
        self.delegate?.didEdit()
        self.refresh()
    }
    
    @objc private func pressDelete() {
        self.delegate?.didDelete()
    }
    
    @objc private func pressEditItems() {
        self.delegate?.didEditItems()
    }
}
