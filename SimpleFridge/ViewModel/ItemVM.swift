//
//  ItemVM.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 21/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import RxCocoa
import RxSwift

class ItemVM {
    
    var fridge: Fridge
    var itemList: BehaviorRelay<[Item]>
    var selectedItem: BehaviorRelay<Item?>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(withFridge fridge: Fridge) {
        self.fridge = fridge
        itemList = BehaviorRelay(value: [])
        selectedItem = BehaviorRelay(value: nil)
    }
    
    func fetchItemData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.predicate = NSPredicate(format: "fridge == %@", fridge as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Item.expireDate), ascending: true)
        request.sortDescriptors = [sort]
        do {
            let data = try context.fetch(request) as! [Item]
            itemList.accept(data)
        } catch {
            print("Fetching item failed")
        }
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        selectedItem.accept(itemList.value[indexPath.row])
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Saving data failed")
        }
    }
    
    func deleteSelectedItem() {
        context.delete(selectedItem.value!)
        selectedItem.accept(nil)
        saveData()
        fetchItemData()
    }
    
}
