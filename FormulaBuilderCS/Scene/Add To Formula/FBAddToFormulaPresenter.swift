//
//  FBAddToFormulaPresenter.swift
//  FormulaBuilderCS
//
//  Created by YI BIN FENG on 2017-02-27.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBAddToFormulaPresenterInput
{
  func presentSomething(response: FBAddToFormula.Something.Response)
}

protocol FBAddToFormulaPresenterOutput: class
{
  func displaySomething(viewModel: FBAddToFormula.Something.ViewModel)
}

class FBAddToFormulaPresenter: FBAddToFormulaPresenterInput
{
  weak var output: FBAddToFormulaPresenterOutput!
  
  // MARK: - Presentation logic
  
  func presentSomething(response: FBAddToFormula.Something.Response)
  {
    // NOTE: Format the response from the Interactor and pass the result back to the View Controller
    
    let viewModel = FBAddToFormula.Something.ViewModel()
    output.displaySomething(viewModel: viewModel)
  }
}
