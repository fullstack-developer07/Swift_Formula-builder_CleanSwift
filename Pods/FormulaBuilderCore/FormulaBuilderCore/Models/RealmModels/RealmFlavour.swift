//
//  RealmFlavor.swift
//  Pods
//
//  Created by Ty Sang on 2017-02-21.
//
//

import RealmSwift

public class RealmFlavour: Object {
  
  public dynamic var id = ""
  public dynamic var name = ""
  
  override public static func primaryKey() -> String? {
    return "id"  
  }
}
