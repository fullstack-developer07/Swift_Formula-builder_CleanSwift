//
//  FBSpeciesConfigurator.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/21/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBSpeciesViewController: FBSpeciesPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension FBSpeciesInteractor: FBSpeciesViewControllerOutput
{
}

extension FBSpeciesPresenter: FBSpeciesInteractorOutput
{
}

class FBSpeciesConfigurator
{
  // MARK: - Object lifecycle
  
  static let sharedInstance = FBSpeciesConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: FBSpeciesViewController)
  {
    let router = FBSpeciesRouter()
    router.viewController = viewController
    
    let presenter = FBSpeciesPresenter()
    presenter.output = viewController
    
    let interactor = FBSpeciesInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
