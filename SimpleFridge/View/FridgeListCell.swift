//
//  FridgeListCell.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 3/1/2562 BE.
//  Copyright © 2562 Natchanon A. All rights reserved.
//

import UIKit

class FridgeListCell: UITableViewCell {
    
    static let identifier = "fridgeListCell"
    
    @IBOutlet weak var fridgeNameLbl: UILabel!
    @IBOutlet weak var itemCountLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func insertData(withFridge fridge: Fridge) {
        fridgeNameLbl.text = fridge.name!
        itemCountLbl.text = "Item count : \(fridge.itemCount)"
    }

}
