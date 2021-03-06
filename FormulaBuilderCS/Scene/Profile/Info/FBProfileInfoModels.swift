//
//  FBProfileInfoModels.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/11/17.
//  Copyright (c) 2017 orgname. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit
import FormulaBuilderCore

struct FBProfileInfo
{
    struct Object
    {
        struct Request{}
        
        struct RequestHerb {
            var herb: FBHerb
        }
        
        struct Response {
            var prepareFormHerbs: [FBHerb]
        }
        
        struct ResponseFlavours {
            var flavours: [String]
        }
        
        struct ResponseNatures {
            var natures: [String]
        }
        
        struct ViewModel {
            var prepareFormHerbs = [DisplayedHerb]()
        }
        
        struct ViewModelItems {
            var content: [String]
        }
    }
}

class DisplayedProfileInfo: NSObject {
    var name = ""
    var englishName = ""
    var chineseName = ""
    var chineseTraditionalName = ""
    var chineseSimplifiedName = ""
    var pinyinTon = ""
    var latinName = ""
    
    init(with formula: FBFormula) {

        name = formula.name
        englishName = "" /// this should be fixed after english name is defined
        chineseName = formula.simplifiedChinese ?? ""
        let simplifiedChinese = formula.simplifiedChinese ?? ""
        if (chineseName.characters.count > 0) {
            chineseName = chineseName + (simplifiedChinese.characters.count > 0 ? "(" + simplifiedChinese + ")" : "")
        } else {
            chineseName = simplifiedChinese
        }
        chineseTraditionalName = formula.traditionalChinese ?? ""
        chineseSimplifiedName = formula.simplifiedChinese ?? ""
        pinyinTon = formula.pinyinTon ?? ""
        
       
    }
    
    init(with herb: FBHerb) {
        
        let herbPinyin = herb.pinyin ?? ""
        
        name = herb.name + ((herbPinyin.characters.count > 0) ? (" (" + herbPinyin + ")") : "")
        englishName = herb.englishCommons.count > 0 ? herb.englishCommons[0] : ""
        chineseTraditionalName = herb.traditionalChinese ?? ""
        chineseSimplifiedName = herb.simplifiedChinese ?? ""
        latinName = herb.latinNames.count > 0 ? herb.latinNames[0] : ""
        if latinName.characters.count > 0
        {
            if englishName.characters.count > 0
            {
                englishName = englishName + "/" + latinName
            }else{
                englishName = latinName
            }
        }
        
        chineseName = herb.simplifiedChinese ?? ""
        let simplifiedChinese = herb.simplifiedChinese ?? ""
        if (chineseName.characters.count > 0) {
            chineseName = chineseName + (simplifiedChinese.characters.count > 0 ? "(" + simplifiedChinese + ")" : "")
        } else {
            chineseName = simplifiedChinese
        }
    }
    
    init(with alternateHerb: FBAlternateHerb) {
        
        let herbPinyin = alternateHerb.pinyin ?? ""
        
        name = alternateHerb.name + ((herbPinyin.characters.count > 0) ? (" (" + herbPinyin + ")") : "")
        englishName = alternateHerb.englishCommons.count > 0 ? alternateHerb.englishCommons[0] : ""
        
        chineseName = alternateHerb.traditionalChinese ?? ""
        let simplifiedChinese = alternateHerb.simplifiedChinese ?? ""
        if (chineseName.characters.count > 0) {
            chineseName = chineseName + (simplifiedChinese.characters.count > 0 ? "(" + simplifiedChinese + ")" : "")
        } else {
            chineseName = simplifiedChinese
        }
    }
    
}
