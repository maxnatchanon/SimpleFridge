//
//  FridgeCell.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 19/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class FridgeCell: UITableViewCell {

    @IBOutlet weak var fridgeNameLbl: UILabel!
    @IBOutlet weak var itemLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
