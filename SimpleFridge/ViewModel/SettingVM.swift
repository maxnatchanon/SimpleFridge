//
//  SettingVM.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 3/1/2562 BE.
//  Copyright © 2562 Natchanon A. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class SettingVM {
    
    var fridgeList: BehaviorRelay<[Fridge]>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fridgeList = BehaviorRelay(value: [])
        fetchFridgeData()
    }
    
    private func fetchFridgeData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        do {
            let data = try context.fetch(request) as! [Fridge]
            fridgeList.accept(data)
        } catch {
            print("Fetch fridge data failed")
        }
    }
    
    private func saveData() {
        do {
            try context.save()
        } catch {
            print("Saving failed in setting screen")
        }
    }
    
    func getFridgeName(atIndexPath indexPath: IndexPath) -> String {
        return fridgeList.value[indexPath.row].name!
    }
    
    func clearFridge(atIndexPath indexPath: IndexPath) {
        let fridge = fridgeList.value[indexPath.row]
        let items = fridge.items?.allObjects as! [Item]
        for item in items {
            fridge.deleteItem(item, in: context)
        }
        saveData()
        fetchFridgeData()
    }
    
    func renameFridge(atIndexPath indexPath: IndexPath, withName name: String) {
        let fridge = fridgeList.value[indexPath.row]
        fridge.name = name
        saveData()
        fetchFridgeData()
    }
    
    func deleteFridge(atIndexPath indexPath: IndexPath) {
        let fridge = fridgeList.value[indexPath.row]
        context.delete(fridge)
        saveData()
        fetchFridgeData()
    }
    
}
