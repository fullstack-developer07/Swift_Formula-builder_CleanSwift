//
//  FBDisplayOptionsInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/16/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBDisplayOptionsInteractorInput
{
  func doSomething(request: FBDisplayOptions.Something.Request)
    var options: [String] { get }
}

protocol FBDisplayOptionsInteractorOutput
{
  func presentSomething(response: FBDisplayOptions.Something.Response)
}

class FBDisplayOptionsInteractor: FBDisplayOptionsInteractorInput
{
  var output: FBDisplayOptionsInteractorOutput!
  var worker: FBDisplayOptionsWorker!
    
    var options = ["Chinese", "Pin Yin", "Latin"]
  
  // MARK: - Business logic
  
  func doSomething(request: FBDisplayOptions.Something.Request)
  {
    // NOTE: Create some Worker to do the work
    
    worker = FBDisplayOptionsWorker()
    worker.doSomeWork()
    
    // NOTE: Pass the result to the Presenter
    
    let response = FBDisplayOptions.Something.Response()
    output.presentSomething(response: response)
  }
}
