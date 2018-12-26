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
    case showAdd = "showAdd"
}

extension UIViewController {
    func performSegue<T:RawRepresentable>(withIdentifier identifier: T, sender: AnyObject?)
        where T.RawValue==String {
        self.performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}

class SegueFromRight: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, aboveSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { (_) in
            src.present(dst, animated: false, completion: nil)
        }
    }
}

class SegueFromRightUnwind: UIStoryboardSegue {
    override func perform() {
        let src = self.source
        let dst = self.destination
        
        src.view.superview?.insertSubview(dst.view, belowSubview: src.view)
        dst.view.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            src.view.transform = CGAffineTransform(translationX: src.view.frame.size.width, y: 0)
        }) { (_) in
            src.dismiss(animated: false, completion: nil)
        }
    }
}
