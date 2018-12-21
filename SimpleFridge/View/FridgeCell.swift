//
//  FridgeCell.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 19/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class FridgeCell: UITableViewCell {
    
    static let identifier = "fridgeCell"

    @IBOutlet weak var fridgeNameLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func insertDataWith(fridge: Fridge) {
        self.fridgeNameLbl.text = fridge.name ?? ""
        self.itemCountLbl.text = String(fridge.itemCount)
    }

}
