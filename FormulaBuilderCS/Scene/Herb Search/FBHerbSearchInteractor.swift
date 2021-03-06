//
//  FBHerbSearchInteractor.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/3/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

protocol FBHerbSearchInteractorInput {
    func fetchHerbs(request: FBHerbSearch.FetchHerbs.Request)
    var herbs: [FBHerb]! { get }
    var formulaSearchViewController: FBFormulaSearchViewController? { get set }
    var homeViewController: FBHomeViewController? { set get }
    var recentSearchViewController: FBRecentSearchesViewController? { set get }
    var addToFormulaViewController: FBAddToFormulaViewController! { set get }
    var profileFormulaViewController: FBProfileFormulasViewController? { set get }
}

protocol FBHerbSearchInteractorOutput {
    func presentFetchedHerbs(response: FBHerbSearch.FetchHerbs.Response)
}

class FBHerbSearchInteractor: FBHerbSearchInteractorInput {
    var output: FBHerbSearchInteractorOutput!
    var herbs: [FBHerb]! = []
    var homeViewController: FBHomeViewController?
    var formulaSearchViewController: FBFormulaSearchViewController?
    var recentSearchViewController: FBRecentSearchesViewController?
    var addToFormulaViewController: FBAddToFormulaViewController!
    var profileFormulaViewController: FBProfileFormulasViewController?
  
    func fetchHerbs(request: FBHerbSearch.FetchHerbs.Request) {
        
        store.fetchHerbs(withFilter: .all) { herbs in
//            if request.category != nil {
//                for herb in herbs {
//                    if request.category!.itemIDs.contains(herb.id) {
//                        self.herbs?.append(herb)
//                    }
//                }
//            } else {
//                self.herbs = herbs
//            }
            
            self.herbs = herbs
            let response = FBHerbSearch.FetchHerbs.Response(herbs: self.herbs!)
            self.output.presentFetchedHerbs(response: response)
        }
    }
}
