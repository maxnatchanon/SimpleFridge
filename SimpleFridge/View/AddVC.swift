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
    
    // MARK:- Variable
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var selectDateBtn: UIButton!
    @IBOutlet weak var dateTextfield: UITextField!
    @IBOutlet weak var iconView: UIStackView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var itemNameTextfield: UITextField!
    @IBOutlet weak var amountTextfield: UITextField!
    @IBOutlet weak var unitTextfield: UITextField!
    
    var fridge: Fridge!
    var addVM: AddVM!
    private let disposeBag = DisposeBag()
    
    
    // MARK:- Main function

    override func viewDidLoad() {
        super.viewDidLoad()

        addVM = AddVM(withFridge: fridge)
        setUpUI()
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
    }
    
    @IBAction func selectDateBtnPressed(_ sender: Any) {
    }
    
    
    
    // MARK:- Subfunction
    
    private func setUpUI() {
        addBtn.layer.cornerRadius = 10
        dateTextfield.isEnabled = false
        
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
    }

}
