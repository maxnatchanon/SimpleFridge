//
//  Fridge.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 3/1/2562 BE.
//  Copyright © 2562 Natchanon A. All rights reserved.
//

import Foundation
import CoreData

extension Fridge {
    
    func initData(withName name: String) {
        self.name = name
        self.itemCount = 0
        self.createDate = Date()
    }
    
    func addItem(_ item: Item) {
        self.addToItems(item)
        item.fridge = self
        self.itemCount += 1
    }
    
    func deleteItem(_ item: Item, in context: NSManagedObjectContext) {
        self.itemCount -= 1
        context.delete(item)
    }
    
}
