//
//  ErrorMessage.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-27.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import UIKit

class ErrorMessage {
    var title: String?
    var message: String?
    
    init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }
    
    func present(on viewController: UIViewController) {
        let alertController = UIAlertController(title: self.title, message: self.message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController.top().present(alertController, animated: true, completion: nil)
    }
    
    static func present(title: String?, message: String, on viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        viewController.top().present(alertController, animated: true, completion: nil)
    }
}
