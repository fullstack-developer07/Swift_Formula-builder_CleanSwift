//
//  FBHistoryConfigurator.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-28.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: - Connect View, Interactor, and Presenter

extension FBHistoryViewController: FBHistoryPresenterOutput
{
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    router.passDataToNextScene(segue: segue)
  }
}

extension FBHistoryInteractor: FBHistoryViewControllerOutput
{
}

extension FBHistoryPresenter: FBHistoryInteractorOutput
{
}

class FBHistoryConfigurator
{
  // MARK: - Object lifecycle
  
  static let sharedInstance = FBHistoryConfigurator()
  
  private init() {}
  
  // MARK: - Configuration
  
  func configure(viewController: FBHistoryViewController)
  {
    let router = FBHistoryRouter()
    router.viewController = viewController
    
    let presenter = FBHistoryPresenter()
    presenter.output = viewController
    
    let interactor = FBHistoryInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}