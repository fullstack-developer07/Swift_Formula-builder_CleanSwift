//
//  FBSpeciesPresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/21/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSpeciesPresenterInput
{
  func presentSomething(response: FBSpecies.Something.Response)
}

protocol FBSpeciesPresenterOutput: class
{
  func displaySomething(viewModel: FBSpecies.Something.ViewModel)
}

class FBSpeciesPresenter: FBSpeciesPresenterInput
{
  weak var output: FBSpeciesPresenterOutput!
  
  // MARK: - Presentation logic
  
  func presentSomething(response: FBSpecies.Something.Response)
  {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    
    let viewModel = FBSpecies.Something.ViewModel()
    output.displaySomething(viewModel: viewModel)
  }
}
