//
//  ListTableHeader.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-30.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

protocol ListTableHeaderDelegate: class {
    func didPressEdit(section: Int)
    func didPressRemove(section: Int)
}

class ListTableHeader: UITableViewHeaderFooterView {
    
    weak var delegate: ListTableHeaderDelegate?
    var section: Int = 0

    var nameLabel: UILabel
    var removeButton: UIButton
    var editButton: UIButton
    
    override init(reuseIdentifier: String?) {
        self.nameLabel = UILabel()
        self.removeButton = UIButton(type: .close)
        self.editButton = UIButton(type: .detailDisclosure)

        super.init(reuseIdentifier: reuseIdentifier)        
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            return stackView
        }()
        
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.editButton)
        stackView.addArrangedSubview(self.removeButton)
        
        self.contentView.addSubviews(stackView)
        
        stackView.constrainTo(view: self.contentView, on: .all, constant: 10)
        
        // actions
        self.editButton.addTarget(self, action: #selector(didPressEdit), for: .touchUpInside)
        self.removeButton.addTarget(self, action: #selector(didPressRemove), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressEdit() {
        self.delegate?.didPressEdit(section: self.section)
    }
    
    @objc func didPressRemove() {
        self.delegate?.didPressRemove(section: self.section)
    }
}
