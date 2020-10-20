//
//  ViewMode.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-20.
//  Copyright © 2020 sandzapps. All rights reserved.
//

enum ViewMode {
    case display
    case edit
}

// TODO: interface for an EditableView
protocol EditableView {
    var mode: ViewMode { get set }
    func setMode(_ mode: ViewMode)
}
