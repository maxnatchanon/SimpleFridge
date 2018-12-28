//
//  IconCell.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 28/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import UIKit

class IconCell: UICollectionViewCell {
    
    static let identifier = "iconCell"
    
    @IBOutlet weak var iconImage: UIImageView!
    
    func initialize(withImageName imageName: String) {
        iconImage.image = UIImage.init(named: imageName)
    }
}
