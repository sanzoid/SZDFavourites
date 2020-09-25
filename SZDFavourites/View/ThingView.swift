//
//  ThingView.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-09-25.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ThingView: UIView {
    
    let nameLabel = UILabel()
    let itemLabel = UILabel()
    
    init(thing: Thing) {
        self.nameLabel.text = "Favorite " + thing.name
        self.itemLabel.text = thing.topItem()?.name ?? "-"
        
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.white.alpha(0.9)

        let stackView: UIStackView = {
            let view = UIStackView()
            view.axis = .vertical
            return view
        }()
        
        self.addSubviews(stackView)
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.itemLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
