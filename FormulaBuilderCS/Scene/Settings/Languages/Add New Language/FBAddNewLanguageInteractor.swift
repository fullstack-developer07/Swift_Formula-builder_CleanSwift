//
//  FBAddNewLanguageInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/17/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBAddNewLanguageInteractorInput
{
    func selectedLanguage(_ language: String)
}

protocol FBAddNewLanguageInteractorOutput
{
  func presentSomething(response: FBAddNewLanguage.Something.Response)
}

class FBAddNewLanguageInteractor: FBAddNewLanguageInteractorInput
{
  var output: FBAddNewLanguageInteractorOutput!
  var worker: FBAddNewLanguageWorker!
    
    func selectedLanguage(_ language: String) {
        
    }
  
  // MARK: - Business logic
  
  func doSomething(request: FBAddNewLanguage.Something.Request)
  {
    // NOTE: Create some Worker to do the work
    
    worker = FBAddNewLanguageWorker()
    worker.doSomeWork()
    
    // NOTE: Pass the result to the Presenter
    
    let response = FBAddNewLanguage.Something.Response()
    output.presentSomething(response: response)
  }
}
