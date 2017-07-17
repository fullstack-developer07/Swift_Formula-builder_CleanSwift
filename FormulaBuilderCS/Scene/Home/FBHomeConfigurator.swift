//
//  FBHomeConfigurator.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBHomeViewController: FBHomePresenterOutput {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        router.passDataToNextScene(segue: segue)
    }
}

extension FBHomeInteractor: FBHomeViewControllerOutput {}

extension FBHomePresenter: FBHomeInteractorOutput {}

class FBHomeConfigurator {

    static let sharedInstance = FBHomeConfigurator()

    private init() {}
  
    func configure(viewController: FBHomeViewController) {
        let router = FBHomeRouter()
        router.viewController = viewController

        let presenter = FBHomePresenter()
        presenter.output = viewController

        let interactor = FBHomeInteractor()
        interactor.output = presenter

        viewController.output = interactor
        viewController.router = router
    }
}