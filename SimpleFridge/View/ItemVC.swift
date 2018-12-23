//
//  ItemVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 22/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ItemVC: UIViewController {
    
    // MARK:- Variable
    
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private var itemVM: ItemVM!
    var fridge: Fridge!
    private let disposeBag = DisposeBag()
    
    
    // MARK:- Main function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemVM = ItemVM(withFridge: fridge)
        setUpTableView()
    }
    
    func setUpTableView() {
        itemTableView.rowHeight = 84
        bindEmptyView()
        bindTableView()
    }

    @IBAction func addBtnPressed(_ sender: Any) {
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        // TODO: Save data?
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // MARK:- Subfunction
    
    func bindEmptyView() {
        itemVM.itemList.asObservable().filter { (list) -> Bool in
            list.count == 0
            }.bind { (list) in
                self.emptyView.alpha = 1
            }.disposed(by: disposeBag)
        
        itemVM.itemList.asObservable().filter { (list) -> Bool in
            list.count > 0
            }.bind { (list) in
                self.emptyView.alpha = 0
            }.disposed(by: disposeBag)
    }
    
    func bindTableView() {
        itemVM.itemList.asObservable()
            .bind(to: itemTableView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) {
                (row, item, cell) in
                cell.insertData(withItem: item)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        itemTableView.rx.modelSelected(Item.self).subscribe(onNext: { (item) in
            // TODO: Show item detail
        }).disposed(by: disposeBag)
    }
    
}
