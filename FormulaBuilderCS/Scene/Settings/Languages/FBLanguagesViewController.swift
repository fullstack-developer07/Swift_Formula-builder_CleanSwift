//
//  FBLanguagesViewController.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/16/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBLanguagesViewControllerInput
{
  func displaySomething(viewModel: FBLanguages.Something.ViewModel)
}

protocol FBLanguagesViewControllerOutput {
    func doSomething(request: FBLanguages.Something.Request)
    var languages: [String] { set get }
}

class FBLanguagesViewController: UITableViewController, FBLanguagesViewControllerInput
{
  var output: FBLanguagesViewControllerOutput!
  var router: FBLanguagesRouter!
  
  // MARK: - Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    FBLanguagesConfigurator.sharedInstance.configure(viewController: self)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    doSomethingOnLoad()
  }
  
  // MARK: - Event handling
  
  func doSomethingOnLoad()
  {
    // NOTE: Ask the Interactor to do some work
    
    let request = FBLanguages.Something.Request()
    output.doSomething(request: request)
  }
  
    func displaySomething(viewModel: FBLanguages.Something.ViewModel) {}
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return output.languages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
            cell?.textLabel?.font = FBFont.SFUIText_Regalur17()
        }
        
        cell?.textLabel?.text = output.languages[indexPath.row]
        cell?.textLabel?.textColor = FBColor.hexColor_030303()
        
        let selectedLanguage = UserDefaults.standard.object(forKey: kSelectedLanguage) as! String
        if cell?.textLabel?.text == selectedLanguage {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == output.languages.count {
            let addNewLanguageViewController = mainStoryboard.instantiateViewController(withIdentifier: "FBAddNewLanguageViewController") as! FBAddNewLanguageViewController
            addNewLanguageViewController.output = self
            navigationController?.pushViewController(addNewLanguageViewController, animated: true)
        } else {
            let language = output.languages[indexPath.row]
            UserDefaults.standard.set(language, forKey: kSelectedLanguage)
            
            tableView.reloadData()
            
            let alert = UIAlertController.init(title: nil, message: "\(language) is your primary language for all app fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    
}

extension FBLanguagesViewController: FBAddNewLanguageViewControllerOutput {

    func selectedLanguage(_ language: String) {
        output.languages.append(language)
        
        tableView.reloadData()
    }
}






