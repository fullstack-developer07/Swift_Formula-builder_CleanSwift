//
//  FBProfileNotesModels.swift
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

struct FBProfileNotes
{
    struct FetchNotes
    {
        struct Request {
            var id: String
        }
        
        struct Response {
            var notes: [FBNote]
        }
        
        struct ViewModel {
            var displayedNotes : [DisplayedNote]
        }
    }
}

class DisplayedNote: NSObject {
    var title = ""
    var content = ""
    var modifiedDate = ""
    var createdDate = ""
    var noteObj : FBNote?
    
    init(with note: FBNote) {
        content = note.content 
        title = note.title

        if (note.modifiedTimestamp > 0) {
            let d = Date(timeIntervalSince1970: note.modifiedTimestamp)
            modifiedDate = "Modified " + Date.dateToStringHumanReadableDate(date: d as Date) + " at " + Date.dateToStringTime(date: d as Date)
        }
        
        let m = Date(timeIntervalSince1970: note.createdTimestamp)
        createdDate = Date.dateToStringHumanReadableDate(date: m as Date) + " at " + Date.dateToStringTime(date: m as Date)
        
        noteObj = note
    }
    
}