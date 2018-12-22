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
        expireMsgLbl.text = getExpireMessage(forItem: item)
        amountLbl.text = String(item.amount)
        unitLbl.text = item.unit ?? ""
    }
    
    private func getExpireMessage(forItem item: Item) -> String {
        // TODO: Generate expire message
        return ""
    }

}
