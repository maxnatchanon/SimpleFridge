//
//  MainVM.swift
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

class MainVM {
    
    var fridgeList: Variable<[Fridge]>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fridgeList = Variable([])
        fetchFridgeData()
    }
    
    func fetchFridgeData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        do {
            fridgeList.value = try context.fetch(request) as! [Fridge]
        } catch {
            print("Fetch fridge data failed")
        }
    }
    
    func addFridge(withName name: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Fridge", in: context)
        let newFridge = NSManagedObject(entity: entity!, insertInto: context)
        newFridge.setValue(name, forKey: "name")
        newFridge.setValue(Date(), forKey: "createDate")
        newFridge.setValue(0, forKey: "itemCount")
        do {
            try context.save()
            fetchFridgeData()
            return true
        } catch {
            print("Saving new fridge failed")
            return false
        }
    }
    
}
