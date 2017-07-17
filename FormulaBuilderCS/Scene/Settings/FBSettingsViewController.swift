//
//  FBSettingsViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/10/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBSettingsViewControllerInput
{
  func displaySomething(viewModel: FBSettings.Something.ViewModel)
}

protocol FBSettingsViewControllerOutput
{
  func doSomething(request: FBSettings.Something.Request)
}

class FBSettingsViewController: UITableViewController, FBSettingsViewControllerInput
{
  var output: FBSettingsViewControllerOutput!
  var router: FBSettingsRouter!
  
  
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    FBSettingsConfigurator.sharedInstance.configure(viewController: self)
  }
  
  
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  
  
  func doSomethingOnLoad()
  {
    
    
    let request = FBSettings.Something.Request()
    output.doSomething(request: request)
  }
  
  
  
  func displaySomething(viewModel: FBSettings.Something.ViewModel)
  {

  }
}