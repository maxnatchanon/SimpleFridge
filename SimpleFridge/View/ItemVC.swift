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
    
    // MARK: - Variable
    
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemTableViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var fridgeNameLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var selectedItemIcon: UIImageView!
    @IBOutlet weak var selectedItemNameLbl: UILabel!
    @IBOutlet weak var selectedItemExpireMsg: UILabel!
    @IBOutlet weak var selectedItemAmount: UILabel!
    @IBOutlet weak var selectedItemDecreaseAmountBtn: UIButton!
    @IBOutlet weak var selectedtemIncreaseAmountBtn: UIButton!
    @IBOutlet weak var selectedItemDateLbl: UILabel!
    
    var fridge: Fridge!
    private var itemVM: ItemVM!
    private let disposeBag: DisposeBag = DisposeBag()
    private var showingItemIndex: Int?
    private var showingCell: ItemCell?
    
    @IBAction func unwindToItem(segue:UIStoryboardSegue){}
    
    
    
    // MARK: - Main function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemVM = ItemVM(withFridge: fridge)
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemVM.fetchItemData()
        itemVM.refreshFilteredList()
        searchBar.text = ""
    }
    
    func setUpUI() {
        itemTableView.rowHeight = 84
        fridgeNameLbl.text = fridge.name!
        bindEmptyView()
        bindTableView()
        bindDetailView()
        setUpDetailView()
        setUpSearchBar()
    }
    
    /// Button function
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.showAdd, sender: fridge)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        itemVM.saveData()
        performSegue(withIdentifier: "unwindToMain", sender: nil)
    }
    
    @IBAction func decreaseAmountBtnPressed(_ sender: Any) {
        itemVM.selectedItem.value!.amount -= 1
        selectedItemAmount.text = String(itemVM.selectedItem.value!.amount)
        showingCell?.amountLbl.text = String(itemVM.selectedItem.value!.amount)
    }
    
    @IBAction func increaseAmountBtnPressed(_ sender: Any) {
        itemVM.selectedItem.value!.amount += 1
        selectedItemAmount.text = String(itemVM.selectedItem.value!.amount)
        showingCell?.amountLbl.text = String(itemVM.selectedItem.value!.amount)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        lockDetailView(hidden: true)
        delay(for: 0.3) {
            self.showingItemIndex = nil
            self.showingCell = nil
            self.itemVM.deleteSelectedItem()
            self.itemVM.filteredItemList.accept(self.itemVM.itemList.filter({ (item) -> Bool in
                item.name!.hasPrefix(self.searchBar.text ?? "")
            }))
        }
    }
    
    
    
    // MARK: - Subfunction
    
    /// Bind emptyView to itemList.count
    /// if there is no item, show emptyView
    private func bindEmptyView() {
        itemVM.filteredItemList.asObservable().filter { (list) -> Bool in
            list.count == 0
            }.bind { (list) in
                self.emptyView.alpha = 1
            }.disposed(by: disposeBag)
        
        itemVM.filteredItemList.asObservable().filter { (list) -> Bool in
            list.count > 0
            }.bind { (list) in
                self.emptyView.alpha = 0
            }.disposed(by: disposeBag)
    }
    
    /// Bind item table view data source to itemList in itemVM
    /// Add row select action, show item detail
    private func bindTableView() {
        itemVM.filteredItemList.asObservable()
            .bind(to: itemTableView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) {
                (row, item, cell) in
                cell.insertData(withItem: item)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        itemTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if (self!.showingItemIndex == nil) {
                self!.showingItemIndex = indexPath.row
                self!.showingCell = (self!.itemTableView.cellForRow(at: indexPath) as! ItemCell)
                self!.itemVM.selectItem(atIndexPath: indexPath)
                delay(for: 0.1, execute: {
                    self!.lockDetailView(hidden: false)
                })
            } else if (self!.showingItemIndex != indexPath.row) {
                self!.lockDetailView(hidden: true)
                delay(for: 0.3, execute: {
                    self!.itemVM.selectItem(atIndexPath: indexPath)
                    self!.showingItemIndex = indexPath.row
                    self!.showingCell = (self!.itemTableView.cellForRow(at: indexPath) as! ItemCell)
                    delay(for: 0.1, execute: {
                        self!.lockDetailView(hidden: false)
                    })
                })
            } else {
                self!.lockDetailView(hidden: true)
                delay(for: 0.3, execute: {
                    self!.showingItemIndex = nil
                    self!.showingCell = nil
                    self!.itemVM.selectedItem.accept(nil)
                })
            }
            
        }).disposed(by: disposeBag)
    }
    
    /// Bind detail view with itemVM.selectedItem
    private func bindDetailView() {
        itemVM.selectedItem.asObservable().bind { (selectedItem) in
                if (selectedItem != nil) {
                    self.selectedItemNameLbl.text = selectedItem!.name!
                    self.selectedItemAmount.text = String(selectedItem!.amount)
                    self.selectedItemExpireMsg.text = selectedItem!.getExpireMessage()
                    self.selectedItemDateLbl.attributedText = selectedItem!.getAttributedDateString()
                }
            }.disposed(by: disposeBag)
    }
    
    /// Set up pan gesture recognizer for detail view
    private func setUpDetailView() {
        detailViewBottomConstraint.constant = -350
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveDetailView(_:)))
        detailView.isUserInteractionEnabled = true
        detailView.addGestureRecognizer(panGesture)
    }
    
    @objc private func moveDetailView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let translation = sender.translation(in: self.view)
            var detailViewConst = detailViewBottomConstraint.constant - translation.y
            detailViewConst = (detailViewConst > 0) ? 0 : detailViewConst
            detailViewBottomConstraint.constant = detailViewConst
            var tableViewConst = itemTableViewBottomConstraint.constant - translation.y
            tableViewConst = (tableViewConst > 350) ? 350 : tableViewConst
            itemTableViewBottomConstraint.constant = tableViewConst
            sender.setTranslation(CGPoint.zero, in: self.view)
        default:
            if (detailViewBottomConstraint.constant > -30) {
                lockDetailView(hidden: false, showDelete: true)
            } else if (detailViewBottomConstraint.constant > -170) {
                lockDetailView(hidden: false)
            } else {
                lockDetailView(hidden: true)
                showingCell = nil
                showingItemIndex = nil
            }
        }
    }
    
    private func lockDetailView(hidden: Bool, showDelete: Bool = false) {
        if (hidden) {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.detailViewBottomConstraint.constant = -350
                self.itemTableViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                self.detailViewBottomConstraint.constant = (showDelete) ? 0 : -50
                self.itemTableViewBottomConstraint.constant = (showDelete) ? 350 : 300
                self.view.layoutIfNeeded()
            }) { (_) in
                self.itemTableView.selectRow(at: IndexPath.init(row: self.showingItemIndex!, section: 0), animated: true, scrollPosition: .middle)
            }
        }
        
    }
    
    /// Bind search bar text and filtered item list
    private func setUpSearchBar() {
        searchBar.rx.text.orEmpty
            .subscribe(onNext: {query in
                self.itemVM.filteredItemList.accept(self.itemVM.itemList.filter({ (item) -> Bool in
                    item.name!.hasPrefix(query)
                }))
            }).disposed(by: disposeBag)
    }

}

extension ItemVC {
    
    /// Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier,
            let identifier = SegueIdentifier(rawValue: identifierString) else {
                return
        }
        
        switch identifier {
        case .showAdd:
            if let addVC = segue.destination as? AddVC, let fridge = sender as? Fridge {
                addVC.fridge = fridge
                self.itemVM.saveData()
                lockDetailView(hidden: true)
                delay(for: 0.3) {
                    self.showingItemIndex = nil
                    self.itemVM.selectedItem.accept(nil)
                }
            }
        default: return
        }
    }
    
}
