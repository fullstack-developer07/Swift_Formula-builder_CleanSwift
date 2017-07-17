//
//  FBDisplayOptionsConfigurator.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/16/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBDisplayOptionsViewController: FBDisplayOptionsPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension FBDisplayOptionsInteractor: FBDisplayOptionsViewControllerOutput
{
}

extension FBDisplayOptionsPresenter: FBDisplayOptionsInteractorOutput
{
}

class FBDisplayOptionsConfigurator
{
  // MARK: - Object lifecycle
  
  static let sharedInstance = FBDisplayOptionsConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: FBDisplayOptionsViewController)
  {
    let router = FBDisplayOptionsRouter()
    router.viewController = viewController
    
    let presenter = FBDisplayOptionsPresenter()
    presenter.output = viewController
    
    let interactor = FBDisplayOptionsInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}