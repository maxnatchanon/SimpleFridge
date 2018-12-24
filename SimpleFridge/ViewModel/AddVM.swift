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
    
    private let errorMessages = ["Item name cannot be empty.",
                                 "Amount must be greater than zero.",
                                 "Unit cannot be empty.",
                                 "Expire date must be after today."]
    
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
        if (expireDate.value <= Date()) { result.append(3) }
        return result
    }
    
    func getErrorMessage(forError errorIdx: [Int]) -> String {
        var message = ""
        for error in errorIdx {
            message += errorMessages[error]
            message += "\n"
        }
        return message
    }
    
    func saveData(completion: ()->Void) {
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)
        let newItem = NSManagedObject(entity: entity!, insertInto: context) as! Item
        newItem.name = itemName.value
        newItem.amount = Int32(amountString.value) ?? 1
        newItem.unit = unit.value.lowercased().capitalized
        newItem.expireDate = expireDate.value
        newItem.addDate = Date()
        newItem.icon = icon.value
        newItem.fridge = fridge
        fridge.items?.adding(newItem)
        fridge.itemCount += 1
        do {
            try context.save()
        } catch {
            print("Saving new item failed")
        }
        completion()
    }
    
}
