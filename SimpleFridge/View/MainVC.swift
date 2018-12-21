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

    // MARK:- Variable
    
    @IBOutlet weak var fridgeTableView: UITableView!
    @IBOutlet weak var addFridgeView: UIView!
    
    private lazy var mainVM: MainVM = { return MainVM() }()
    private let disposeBag = DisposeBag()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    
    // MARK:- Main function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainVM.fetchFridgeData()
    }
    
    private func setUpTableView() {
        fridgeTableView.rowHeight = 80
        setUpAddFridgeBtn()
        bindTableView()
    }
    
    @IBAction func settingBtnPressed(_ sender: Any) {
        // TODO: Show setting screen
    }
    
    

    // MARK:- Subfunction
    
    /// Add gesture recognizer for addFridgeView
    /// When tapped, call showAddFridgeAlert()
    private func setUpAddFridgeBtn() {
        addFridgeView.layer.cornerRadius = 10
        let addFridgeTap = UITapGestureRecognizer(target: self, action: #selector(self.showAddFridgeAlert))
        addFridgeView.addGestureRecognizer(addFridgeTap)
    }
    
    /// Show alert with textfield for user to type in the new fridge name
    /// Try creating new fridge with that name
    /// If failed, show fail alert with function below
    @objc private func showAddFridgeAlert() {
        let alert = UIAlertController(title: "Add new fridge", message: "Enter fridge name", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Kitchen"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0]
            if (textField.text! != "") {
                if (!self.mainVM.addFridge(withName: textField.text!)) {
                    self.showAddFridgeFailAlert(withMessage: "Please try again.")
                }
            } else {
                self.showAddFridgeFailAlert(withMessage: "Fridge name cannot be empty.")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAddFridgeFailAlert(withMessage message: String) {
        let unsuccessAlert = UIAlertController(title: "Adding failed", message: message, preferredStyle: .alert)
        unsuccessAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(unsuccessAlert, animated: true, completion: nil)
    }
    
    /// Bind fridge table view data source to fridgeList in mainVM
    /// Add row select action, go to item screen
    private func bindTableView() {
        mainVM.fridgeList.asObservable()
            .bind(to: fridgeTableView.rx.items(cellIdentifier: FridgeCell.identifier, cellType: FridgeCell.self)) {
                (row, fridge, cell) in
                cell.insertDataWith(fridge: fridge)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        fridgeTableView.rx.modelSelected(Fridge.self).subscribe(onNext: { (fridge) in
            // TODO: Go to item screen with 'fridge'
            if let selectedRowIndexPath = self.fridgeTableView.indexPathForSelectedRow {
                self.fridgeTableView.deselectRow(at: selectedRowIndexPath, animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
}
