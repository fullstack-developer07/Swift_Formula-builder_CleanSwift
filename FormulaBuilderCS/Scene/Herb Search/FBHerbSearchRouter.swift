//
//  FBHerbSearchRouter.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol FBHerbSearchRouterInput
{
    func navigateToProfilePage(profileViewType: ProfileViewType)
}

class FBHerbSearchRouter: FBHerbSearchRouterInput
{
    weak var viewController: FBHerbSearchViewController!
  
    // MARK: - Navigation

    func navigateToProfilePage(profileViewType: ProfileViewType) {
        if let selectedIndexPath = viewController.tableView.indexPathForSelectedRow {
            if let selectedHerb = viewController.displayedHerbs[selectedIndexPath.row].herbObj {
                let navigationController = viewController.navigationController
                let profileViewController = profileStoryboard.instantiateViewController(withIdentifier: "FBProfileViewController") as! FBProfileViewController
                profileViewController.profileViewType = profileViewType
                profileViewController.herb = selectedHerb
                navigationController?.pushViewController(profileViewController, animated: true)
            }
        }
    }

    // MARK: - Communication

    func passDataToNextScene(segue: UIStoryboardSegue) {

        if segue.identifier == "FBAddToFormulaViewController" {
          
            viewController.output.addToFormulaViewController = segue.destination as! FBAddToFormulaViewController
            
            (segue.destination as! FBAddToFormulaViewController).output.herbSearchViewController = viewController
            
        }
    }
}
