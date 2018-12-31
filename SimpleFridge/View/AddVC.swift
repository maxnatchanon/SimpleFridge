//
//  AddVC.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 23/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddVC: UIViewController {
    
    // MARK: - Variable
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var iconView: UIStackView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var itemNameTextfield: UITextField!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var unitTextfield: UITextField!
    @IBOutlet weak var datePickerView: DatePickerView!
    
    var fridge: Fridge!
    var addVM: AddVM!
    private let disposeBag = DisposeBag()
    
    
    // MARK: - Main function

    override func viewDidLoad() {
        super.viewDidLoad()

        addVM = AddVM(withFridge: fridge)
        setUpUI()
    }
    
    
    
    // MARK: - Button action
    
    /// Check if all data is valid then save
    /// If not, show error alert
    @IBAction func addBtnPressed(_ sender: Any) {
        let checkData = addVM.checkData()
        if (checkData.count == 0) {
            addVM.saveData {
                dismiss(animated: true, completion: nil)
            }
        } else {
            let errorMessage = addVM.getErrorMessage(forError: checkData)
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Cancel", message: "Cancel adding new item?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (alertAction) in
            self.performSegue(withIdentifier: "unwindToItem", sender: nil)
        }))
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func selectDateBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.datePickerView.alpha = 1
        }
    }
    
    
    
    // MARK: - Subfunction
    
    private func setUpUI() {
        addBtn.layer.cornerRadius = 10
        dateTextfield.isEnabled = false
        
        setUpIconView()
        setUpDatePickerView()
        
        itemNameTextfield.rx.text.orEmpty.asObservable()
            .bind(to: addVM.itemName).disposed(by: disposeBag)
        
        amountTextfield.rx.text.orEmpty.asObservable()
            .bind(to: addVM.amountString).disposed(by: disposeBag)
        
        unitTextfield.rx.text.orEmpty.asObservable()
            .bind(to: addVM.unit).disposed(by: disposeBag)
        
        addVM.icon.asObservable().bind { (icon) in
            self.iconImage.image = UIImage.init(named: icon)
            }.disposed(by: disposeBag)
        
        addVM.expireDate.asObservable().bind { (date) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.dateTextfield.text = dateFormatter.string(from: date)
            }.disposed(by: disposeBag)
        
        addVM.icon.asObservable().bind { (icon) in
                self.iconImage.image = UIImage.init(named: icon)
            }.disposed(by: disposeBag)
    }

    private func setUpIconView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showIconSelectScreen))
        iconView.addGestureRecognizer(tapGesture)
        iconView.isUserInteractionEnabled = true
    }
    
    private func setUpDatePickerView() {
        datePickerView.alpha = 0
        datePickerView.btnFunction = { [weak self] () in
            self?.addVM.expireDate.accept((self?.datePickerView.selectedDate)!)
            UIView.animate(withDuration: 0.3) {
                self?.datePickerView.alpha = 0
            }
        }
    }
    
    @objc private func showIconSelectScreen() {
        performSegue(withIdentifier: SegueIdentifier.showIcon, sender: nil)
    }
    
}

extension AddVC: DataPassable {
    func pass(data: String) {
        addVM.icon.accept(data)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifierString = segue.identifier,
            let identifier = SegueIdentifier(rawValue: identifierString) else {
                return
        }
        
        switch identifier {
        case .showIcon:
            if let iconVC = segue.destination as? IconVC {
                iconVC.delegate = self
            }
        default:
            return
        }
    }
    
}
