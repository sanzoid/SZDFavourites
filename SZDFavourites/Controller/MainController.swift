//
//  MainController.swift
//  SZDFavourites
//
//  Created by Sandy House on 2020-10-10.
//  Copyright © 2020 sandzapps. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class MainController: UIViewController {
    
    let viewModel: ListViewModel
    let listController: ListController
    weak var groupController: GroupController?
    weak var thingController: ThingController?
    
    let adBannerUnitId = "ca-app-pub-3940256099942544/2934735716" // test
//    let adBannerUnitId = "ca-app-pub-8602369244729374/1479129282" // prod
    var adBanner: GADBannerView?
    
    
    init(model: Model) {
        self.viewModel = ListViewModel(model: model, properties: ListProperties())
        self.listController = ListController()
        
        super.init(nibName: nil, bundle: nil)
        
        self.listController.dataSource = self
        self.listController.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.title = "FAVLIST"
        
        self.addChildDefault(viewController: self.listController)
        self.listController.view.constrainToEdge(of: self.view, placement: .leadingAndTrailing, constant: 10)
        self.listController.view.constrainToEdge(of: self.view, placement: .topToTop, constant: 10, priority: .required)
        self.listController.view.constrainToEdge(of: self.view, placement: .bottomToBottom)
        self.listController.view.constrainToCenter(of: self.view, axis: .x, constant: 0)
        self.view.backgroundColor = .white
        
        self.addBarButtonItems()
        
        // ad
        self.addAd()
        self.loadAd()
    }
    
    func addBarButtonItems() {
        let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressThingButton))
        let addGroupBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(pressGroupButton))
        self.navigationItem.setRightBarButtonItems([addBarButtonItem, addGroupBarButtonItem], animated: true)
    }
    
    func addAd() {
        let adBanner = self.getAdBanner()
        
        self.view.addSubviews(adBanner)
        adBanner.constrainToEdge(of: self.view, placement: .bottomToBottom, withinSafeArea: false, constant: 0)
        adBanner.constrainToCenter(of: self.view, axis: .x, constant: 0)
        
        self.adBanner = adBanner
    }
    
    // MARK: Actions
    
    @objc func pressGroupButton() {
        self.presentGroupController()
    }
    
    @objc func pressThingButton() {
        self.presentAddThingController()
    }
    
    // MARK: Navigation
    
    func presentGroupController() {
        let groupController = GroupController()
        groupController.delegate = self
        groupController.dataSource = self
        self.groupController = groupController
        
        let navigationController = UINavigationController(rootViewController: groupController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func presentThingController(with name: ThingName, isAdd: Bool) {
        guard let thing = self.viewModel.thing(with: name) else { return }
        self.presentThingController(thing: thing, isAdd: isAdd)
    }
    
    func presentThingController(at index: ThingIndex, isAdd: Bool) {
        let thing = self.viewModel.thing(at: index)
        self.presentThingController(thing: thing, isAdd: isAdd)
    }
    
    func presentThingController(thing: Thing, isAdd: Bool) {
        self.viewModel.selectedThing = thing
        
        let thingController = ThingController()
        thingController.delegate = self
        thingController.dataSource = self
        thingController.refresh()
        thingController.setEdit(isAdd) // add: default to edit mode
        
        thingController.modalPresentationStyle = .overFullScreen
        
        self.thingController = thingController
        
        self.present(thingController, animated: true, completion: nil)
    }
}

// MARK: AdMob
extension MainController {
    func getAdBanner() -> GADBannerView {
        let adBanner = GADBannerView(adSize: kGADAdSizeBanner)
        return adBanner
    }
    
    func loadAd() {
        guard let adBanner = self.adBanner else { return }
        adBanner.adUnitID = self.adBannerUnitId
        adBanner.rootViewController = self
        adBanner.load(GADRequest())
    }
}

extension MainController {
    // TODO: These will be their own controllers
    
    // MARK: Add Thing Controller
    
    func presentAddThingController() {
        var title: String
        var actionTitle: String
        var actionBlock: (String) -> Void
        title = "Add Thing"
        actionTitle = "Add"
        actionBlock = { thingText in
            if let error = self.viewModel.add(thing: thingText) {
                // handle error
                let errorMessage = ErrorMessage(title: error.title, message: error.message) {
                    self.presentAddThingController()
                }
                errorMessage.present(on: self)
            } else {
                self.listController.refresh()
                self.presentThingController(with: thingText, isAdd: true)
            }
        }
        
        // alert controller dialog for adding thing name + item name
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: actionTitle, style: .default) { action in
            guard let thingText = alertController.textFields?[0].text else { return }
            actionBlock(thingText)
        }
        alertController.addTextFields(("Name", nil))
        alertController.addActions(cancelAction, addAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
