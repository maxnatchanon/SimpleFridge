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
    
    var fridgeList: BehaviorRelay<[Fridge]>
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init() {
        fridgeList = BehaviorRelay(value: [])
        fetchFridgeData()
    }
    
    func fetchFridgeData() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        do {
            let data = try context.fetch(request) as! [Fridge]
            fridgeList.accept(data)
        } catch {
            print("Fetch fridge data failed")
        }
    }
    
    func addFridge(withName name: String) -> Bool {
        let entity = NSEntityDescription.entity(forEntityName: "Fridge", in: context)
        let newFridge = NSManagedObject(entity: entity!, insertInto: context) as! Fridge
        newFridge.initData(withName: name)
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
