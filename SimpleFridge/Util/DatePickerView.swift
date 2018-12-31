//
//  DatePickerView.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 31/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class DatePickerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var submitBtn: UIButton!
    
    var btnFunction: (()->())?
    var selectedDate: Date {
        return datePicker.date
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeView()
        
    }
    
    private func initializeView() {
        Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        container.layer.cornerRadius = 10
        container.clipsToBounds = true
    }
    
    func setInitialDate(withDate date: Date) {
        datePicker.date = date
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        btnFunction?()
    }
    
}
