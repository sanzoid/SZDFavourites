//
//  ListHeader.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-12.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ListHeader: UITableViewHeaderFooterView {
    
    private var nameLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor(red: 71/255, green: 71/255, blue: 71/255, alpha: 1)
        let nameLabel: UILabel = {
            let view = UILabel()
            view.textColor = .white
            view.font = .systemFont(ofSize: 18, weight: .semibold)
            return view
        }()
        
        self.contentView.addSubviews(containerView)
        containerView.addSubviews(nameLabel)
        
        containerView.constrainToEdge(of: self.contentView, placement: .all)
        nameLabel.constrainToEdge(of: containerView, placement: .leadingToLeading, constant: 10)
        nameLabel.constrainToCenter(of: containerView, axis: .y, constant: 5)
        
        self.nameLabel = nameLabel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setValues(name: String) {
        self.nameLabel.text = name
    }
}
