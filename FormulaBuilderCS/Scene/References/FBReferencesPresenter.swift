//
//  FBReferencesPresenter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBReferencesPresenterInput
{
  func presentSomething(response: FBReferences.Something.Response)
}

protocol FBReferencesPresenterOutput: class
{
  func displaySomething(viewModel: FBReferences.Something.ViewModel)
}

class FBReferencesPresenter: FBReferencesPresenterInput
{
  weak var output: FBReferencesPresenterOutput!
  
  
  
  func presentSomething(response: FBReferences.Something.Response)
  {
    
    
    let viewModel = FBReferences.Something.ViewModel()
    output.displaySomething(viewModel: viewModel)
  }
}