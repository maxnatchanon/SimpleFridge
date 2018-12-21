//
//  MainVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 17/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

class MainVC: UIViewController {

    @IBOutlet weak var fridgeTableView: UITableView!
    
    private var fridgeList = [Fridge]()
    private let disposeBag = DisposeBag()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Fridge")
        do {
            fridgeList = try context.fetch(request) as! [Fridge]
        } catch {
            print("Fetching at edit page failed")
        }
        
        setUpTableView()
    }
    
    private func setUpTableView() {
        // Set row height
        fridgeTableView.rowHeight = 80
        
        // Bind data source
        let observableFridgeList = Observable.just(fridgeList)
        observableFridgeList
            .bind(to: fridgeTableView.rx.items(cellIdentifier: FridgeCell.identifier, cellType: FridgeCell.self)) {
            (row, fridge, cell) in
            cell.insertDataWith(fridge: fridge)
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        fridgeTableView.rx.modelSelected(Fridge.self)
            .subscribe(onNext: { (fridge) in
                // TODO: Go to item screen with 'fridge'
                
                if let selectedRowIndexPath = self.fridgeTableView.indexPathForSelectedRow {
                    self.fridgeTableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        // TODO: Show setting screen
    }
    
}
