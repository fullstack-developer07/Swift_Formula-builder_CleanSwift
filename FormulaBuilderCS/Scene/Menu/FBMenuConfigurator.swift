//
//  FBMenuConfigurator.swift
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

extension FBMenuViewController: FBMenuPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension FBMenuInteractor: FBMenuViewControllerOutput
{
}

extension FBMenuPresenter: FBMenuInteractorOutput
{
}

class FBMenuConfigurator
{
  
  
  static let sharedInstance = FBMenuConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: FBMenuViewController)
  {
    let router = FBMenuRouter()
    router.viewController = viewController
    
    let presenter = FBMenuPresenter()
    presenter.output = viewController
    
    let interactor = FBMenuInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
