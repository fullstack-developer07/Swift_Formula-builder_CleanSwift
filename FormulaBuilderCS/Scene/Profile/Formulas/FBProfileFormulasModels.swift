//
//  FBProfileFormulasModels.swift
//  FormulaBuilderCS
//
//  Created by a on 2/19/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

struct FBProfileFormulas
{
    struct FetchFormulas {
        
        struct Request {}
        
        struct Response {
            var formulas: [FBFormula]
        }
        
        struct ViewModel {
            var displayedFormulas: [DisplayedFormula]
        }
    }
}