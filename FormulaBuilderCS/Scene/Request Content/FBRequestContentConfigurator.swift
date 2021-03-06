//
//  FBRequestContentConfigurator.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/7/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBRequestContentViewController: FBRequestContentPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension FBRequestContentInteractor: FBRequestContentViewControllerOutput
{
}

extension FBRequestContentPresenter: FBRequestContentInteractorOutput
{
}

class FBRequestContentConfigurator
{
  
  
  static let sharedInstance = FBRequestContentConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: FBRequestContentViewController)
  {
    let router = FBRequestContentRouter()
    router.viewController = viewController
    
    let presenter = FBRequestContentPresenter()
    presenter.output = viewController
    
    let interactor = FBRequestContentInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
