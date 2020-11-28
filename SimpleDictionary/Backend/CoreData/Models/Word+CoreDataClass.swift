//
//  Word+CoreDataClass.swift
//  SimpleDictionary
//
//  Created by Oleg Kosenko on 2020-11-14.
//
//

import Foundation
import CoreData

@objc(Word)
class Word: NSManagedObject {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
    }
}
