//
//  ItemCell.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 22/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    static let identifier = "itemCell"

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var expireMsgLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var unitLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func insertData(withItem item: Item) {
        itemIcon.image = UIImage.init(named: item.icon ?? "")
        itemNameLbl.text = item.name ?? ""
        expireMsgLbl.text = item.getExpireMessage()
        amountLbl.text = String(item.amount)
        unitLbl.text = item.unit ?? ""
        
        let dayCount = item.getDayCountToExpireDate()
        if (dayCount < 0) {
            containerView.backgroundColor = UIColor.init(red: 213, green: 213, blue: 213, alpha: 1)
        } else if (item.getDayCountToExpireDate() <= 1) {
            containerView.backgroundColor = UIColor.init(red: 255, green: 0, blue: 0, alpha: 0.09)
        }
    }

}
