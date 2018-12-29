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
    var itemList: [Item]
    var filteredItemList: BehaviorRelay<[Item]>
    var selectedItem: BehaviorRelay<Item?>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(withFridge fridge: Fridge) {
        self.fridge = fridge
        itemList = []
        filteredItemList = BehaviorRelay(value: [])
        selectedItem = BehaviorRelay(value: nil)
    }
    
    func fetchItemData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        request.predicate = NSPredicate(format: "fridge == %@", fridge as CVarArg)
        let sort = NSSortDescriptor(key: #keyPath(Item.expireDate), ascending: true)
        request.sortDescriptors = [sort]
        do {
            let data = try context.fetch(request) as! [Item]
            itemList = data
        } catch {
            print("Fetching item failed")
        }
    }
    
    func refreshFilteredList(withQuery query: String = "") {
        filteredItemList.accept(itemList.filter({ (item) -> Bool in
            item.name!.hasPrefix(query)
        }))
    }
    
    func selectItem(atIndexPath indexPath: IndexPath) {
        selectedItem.accept(filteredItemList.value[indexPath.row])
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
        fridge.itemCount -= 1
        selectedItem.accept(nil)
        saveData()
        fetchItemData()
    }
    
    func editSelectedItemName(withName name: String) {
        selectedItem.value!.name = name
        saveData()
    }
    
    func editSelectedItemAmount(withAmount amount: Int32) {
        selectedItem.value!.amount = amount
        saveData()
    }
    
    func editSelectedItemExpireDate(withDate date: Date) {
        selectedItem.value!.expireDate = date
        saveData()
    }
    
}
