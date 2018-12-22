//
//  Segue.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 22/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import Foundation
import UIKit

enum SegueIdentifier: String {
    case showItem = "showItem"
}

extension UIViewController {
    func performSegue<T:RawRepresentable>(withIdentifier identifier: T, sender: AnyObject?)
        where T.RawValue==String {
        self.performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}
