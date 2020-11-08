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
        stackView.constrainToEdge(of: self.contentView, placement: .all, constant: contentMargin)
        
        thingContainer.constrainToSize(constant: 25, dimension: .height, relativity: .greaterThanOrEqual)
        itemContainer.constrainToSize(constant: 25, dimension: .height, relativity: .greaterThanOrEqual)
        
        itemLabel.constrainToCenter(of: stackView, axis: .y)
        thingLabel.constrainToEdge(of: itemLabel, placement: .bottomToBottom, constant: 0)
        
        itemLabel.constrainToEdge(of: itemContainer, placement: .leadingAndTrailing)
        thingLabel.constrainToEdge(of: thingContainer, placement: .leadingAndTrailing)
        
        // reference
        self.thingLabel = thingLabel
        self.itemLabel = itemLabel
        
//        itemLabel.showTestOutline()
//        itemContainer.showTestOutline()
//        thingLabel.showTestOutline()
//        thingContainer.showTestOutline()
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
