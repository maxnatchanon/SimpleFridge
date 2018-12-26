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
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var detailViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var selectedItemIcon: UIImageView!
    @IBOutlet weak var selectedItemNameLbl: UILabel!
    @IBOutlet weak var selectedItemExpireMsg: UILabel!
    
    var fridge: Fridge!
    private let disposeBag = DisposeBag()
    var showingDetailView = false
    
    
    // MARK:- Main function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemVM = ItemVM(withFridge: fridge)
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemVM.fetchItemData()
    }
    
    func setUpUI() {
        itemTableView.rowHeight = 84
        bindEmptyView()
        bindTableView()
        bindDetailView()
        setUpDetailView()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifier.showAdd, sender: fridge)
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        // TODO: Save data?
        //self.dismiss(animated: false, completion: nil)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    
    
    // MARK:- Subfunction
    
    /// Bind emptyView to itemList.count
    /// if there is no item, show emptyView
    private func bindEmptyView() {
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
    
    /// Bind item table view data source to itemList in itemVM
    /// Add row select action, show item detail
    private func bindTableView() {
        itemVM.itemList.asObservable()
            .bind(to: itemTableView.rx.items(cellIdentifier: ItemCell.identifier, cellType: ItemCell.self)) {
                (row, item, cell) in
                cell.insertData(withItem: item)
                cell.selectionStyle = .none
            }.disposed(by: disposeBag)
        
        itemTableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if (!(self!.showingDetailView)) {
                self!.itemVM.selectItem(atIndexPath: indexPath)
                self!.lockDetailView(hidden: false)
            } else {
                self!.lockDetailView(hidden: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    self!.itemVM.selectItem(atIndexPath: indexPath)
                    self!.lockDetailView(hidden: false)
                })
            }
            
        }).disposed(by: disposeBag)
    }
    
    /// Bind detail view with itemVM.selectedItem
    private func bindDetailView() {
        itemVM.selectedItem.asObservable().bind { (selectedItem) in
                if (selectedItem != nil) {
                    self.selectedItemNameLbl.text = selectedItem!.name!
                    // TODO: Add all detail
                }
            }.disposed(by: disposeBag)
    }
    
    /// Set up pan gesture recognizer for detail view
    private func setUpDetailView() {
        detailViewBottomConstraint.constant = -300
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.moveDetailView(_:)))
        detailView.isUserInteractionEnabled = true
        detailView.addGestureRecognizer(panGesture)
    }
    
    @objc private func moveDetailView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            let translation = sender.translation(in: self.view)
            var newConst = detailViewBottomConstraint.constant - translation.y
            newConst = (newConst > 0) ? 0 : newConst
            detailViewBottomConstraint.constant = newConst
            sender.setTranslation(CGPoint.zero, in: self.view)
        default:
            if (detailViewBottomConstraint.constant > -120) {
                lockDetailView(hidden: false)
            } else {
                lockDetailView(hidden: true)
            }
        }
    }
    
    private func lockDetailView(hidden: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.detailViewBottomConstraint.constant = (hidden) ? -300 : 0
            self.view.layoutIfNeeded()
        })
    }
    
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
            }
        default: return
        }
    }
    
}
