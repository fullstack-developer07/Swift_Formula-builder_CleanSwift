//
//  FBSettingsInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSettingsInteractorInput
{
  func doSomething(request: FBSettings.Something.Request)
}

protocol FBSettingsInteractorOutput
{
  func presentSomething(response: FBSettings.Something.Response)
}

class FBSettingsInteractor: FBSettingsInteractorInput
{
  var output: FBSettingsInteractorOutput!
  var worker: FBSettingsWorker!
  
  
  
  func doSomething(request: FBSettings.Something.Request)
  {
    
    
    worker = FBSettingsWorker()
    worker.doSomeWork()
    
    
    
    let response = FBSettings.Something.Response()
    output.presentSomething(response: response)
  }
}