//
//  Definition+CoreDataClass.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//
//

import Foundation
import CoreData

@objc(Definition)
class Definition: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        // uuid = UUID()
    }
}
