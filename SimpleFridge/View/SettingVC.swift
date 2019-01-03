//
//  SettingVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 3/1/2562 BE.
//  Copyright © 2562 Natchanon A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingVC: UIViewController {
    
    // MARK: - Variable
    
    @IBOutlet weak var expireNotificationSwitch: UISwitch!
    @IBOutlet weak var fridgeListTableView: UITableView!
    
    private let settingVM: SettingVM = { return SettingVM() }()
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - Main function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    private func setUpTableView() {
        fridgeListTableView.delegate = self
        //fridgeListTableView.separatorColor = UIColor.init(red: 242/255, green: 242/255, blue: 243/255, alpha: 1.0)
        fridgeListTableView.rowHeight = 60
        settingVM.fridgeList.asObservable().bind(to: fridgeListTableView.rx.items(cellIdentifier: FridgeListCell.identifier, cellType: FridgeListCell.self)) {
                (row, fridge, cell) in
                cell.insertData(withFridge: fridge)
            }.disposed(by: disposeBag)
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension SettingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let clearAction = UIContextualAction(style: .normal, title: "Clear") { (action, view, handler) in
            self.showClearAlert(forIndexPath: indexPath)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.showDeleteAlert(forIndexPath: indexPath)
        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, clearAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameAction = UIContextualAction(style: .normal, title: "Rename") { (action, view, handler) in
            self.showRenameAlert(forIndexPath: indexPath)
        }
        let configuration = UISwipeActionsConfiguration(actions: [renameAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    private func showClearAlert(forIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: "Clear all items", message: "Remove all items in this fridge.\nThis cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (alert) in
            self.settingVM.clearFridge(atIndexPath: indexPath)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showDeleteAlert(forIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete fridge", message: "This will delete this fridge and all items in this fridge.\nThis cannot be undone.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { (alert) in
            self.settingVM.deleteFridge(atIndexPath: indexPath)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showRenameAlert(forIndexPath indexPath: IndexPath) {
        let alert = UIAlertController(title: "Rename fridge", message: "Enter new fridge name", preferredStyle: .alert)
        alert.addTextField { (textfield) in
            textfield.placeholder = self.settingVM.getFridgeName(atIndexPath: indexPath)
            textfield.textAlignment = .center
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            let textfield = alert.textFields![0]
            if (textfield.text != "") {
                self.settingVM.renameFridge(atIndexPath: indexPath, withName: textfield.text!)
            } else {
                let unsuccessAlert = UIAlertController(title: "Rename failed", message: "Fridge name cannot be empty.", preferredStyle: .alert)
                unsuccessAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(unsuccessAlert, animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
