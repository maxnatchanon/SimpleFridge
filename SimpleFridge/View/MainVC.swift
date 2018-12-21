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
    @IBOutlet weak var addFridgeView: UIView!
    
    private var fridgeList = [Fridge]() // TODO: Move this to VM
    private let disposeBag = DisposeBag()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        // Set row height
        fridgeTableView.rowHeight = 80
        addFridgeView.layer.cornerRadius = 10
        
        // Bind data source
        let observableFridgeList = Observable.just(fridgeList)
        observableFridgeList
            .bind(to: fridgeTableView.rx.items(cellIdentifier: FridgeCell.identifier, cellType: FridgeCell.self)) {
            (row, fridge, cell) in
            cell.insertDataWith(fridge: fridge)
            cell.selectionStyle = .none
        }.disposed(by: disposeBag)
        
        // Select row action
        fridgeTableView.rx.modelSelected(Fridge.self).subscribe(onNext: { (fridge) in
            // TODO: Go to item screen with 'fridge'
            
            if let selectedRowIndexPath = self.fridgeTableView.indexPathForSelectedRow {
                self.fridgeTableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)
        
        // Add fridge button
        let addFridgeTap = UITapGestureRecognizer(target: self, action: #selector(self.showAddFridgeScn))
        addFridgeView.addGestureRecognizer(addFridgeTap)
    }
    
    @objc private func showAddFridgeScn() {
        // TODO: Show screen
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        // TODO: Show setting screen
    }
    
}
