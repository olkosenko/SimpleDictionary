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
public class Word: NSManagedObject {
    override func awakeFromInsert() {
        super.awakeFromInsert()
        uuid = UUID()
    }
}
