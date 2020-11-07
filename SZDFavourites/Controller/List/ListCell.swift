//
//  ListCell.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    private var thingLabel = UILabel()
    private var itemLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        let contentMargin: CGFloat = 10
        
        // initialize
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = contentMargin
            return stackView
        }()
        let thingContainer = UIView()
        let itemContainer = UIView()
        let thingLabel: UILabel = {
            let view = UILabel()
            view.lineBreakMode = .byTruncatingTail
            view.textAlignment = .left
            view.font = .systemFont(ofSize: 14, weight: .regular)
            view.textColor = .darkGray
            return view
        }()
        let itemLabel: UILabel = {
            let view = UILabel()
            view.lineBreakMode = .byTruncatingTail
            view.textAlignment = .right
            view.font = .systemFont(ofSize: 16, weight: .light)
            return view
        }()
        
        // hierarchy
        self.contentView.addSubviews(stackView)
        stackView.addArrangedSubview(thingContainer)
        stackView.addArrangedSubview(itemContainer)
        thingContainer.addSubviews(thingLabel)
        itemContainer.addSubviews(itemLabel)
        
        // constraint
        stackView.constrainTo(view: self.contentView, on: .all, constant: contentMargin)
        
        thingContainer.constrainToHeight(constant: 25)
        itemContainer.constrainToHeight(constant: 25)
        
        thingLabel.constrainToVertical(of: itemContainer, axis: .bottom, constant: 0)
        thingLabel.constrainToHorizontal(of: thingContainer)
        itemLabel.constrainToCenter(of: itemContainer, axis: .y, constant: 0)
        itemLabel.constrainToHorizontal(of: itemContainer)
        
        // reference
        self.thingLabel = thingLabel
        self.itemLabel = itemLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValues(thing: String, item: String?) {
        self.thingLabel.text = thing
        
        if let item = item {
            self.itemLabel.textColor = .black
            self.itemLabel.text = item
        } else {
            self.itemLabel.textColor = .lightGray
            self.itemLabel.text = "-"
        }
    }
}
