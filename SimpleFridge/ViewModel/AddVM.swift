//
//  AddVM.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 23/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa

class AddVM {
    
    var fridge: Fridge
    var itemName: BehaviorRelay<String>
    var amountString: BehaviorRelay<String>
    var unit: BehaviorRelay<String>
    var expireDate: BehaviorRelay<Date>
    var icon: BehaviorRelay<String>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(withFridge fridge : Fridge) {
        self.fridge = fridge
        itemName = BehaviorRelay(value: "")
        amountString = BehaviorRelay(value: "")
        unit = BehaviorRelay(value: "")
        expireDate = BehaviorRelay(value: Date())
        icon = BehaviorRelay(value: "")
    }
    
    func checkData() -> [Int] {
        var result: [Int] = []
        if (itemName.value == "") { result.append(0) }
        if (amountString.value == "" || amountString.value == "0") { result.append(1) }
        if (unit.value == "") { result.append(2) }
        if (expireDate.value < Date()) { result.append(3) }
        return result
    }
    
    func saveData() {
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context)
        newItem.setValue(itemName.value, forKey: "name")
        newItem.setValue(Int(amountString.value), forKey: "amount")
        newItem.setValue(unit.value.lowercased().capitalized, forKey: "unit")
        newItem.setValue(expireDate.value, forKey: "expireDate")
        newItem.setValue(Date(), forKey: "addDate")
        newItem.setValue(icon.value, forKey: "icon")
        do {
            try context.save()
        } catch {
            print("Saving new item failed")
        }
    }
    
}
