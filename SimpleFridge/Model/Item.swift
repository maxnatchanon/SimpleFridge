//
//  Item.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 26/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import Foundation
import UIKit

extension Item {
    func getDayCountToExpireDate() -> Int {
        let today = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let interval = self.expireDate!.timeIntervalSince(today)
        return Int(interval/(60 * 60 * 24))
    }
    
    func getExpireMessage() -> String {
        var message = ""
        let dayCount = self.getDayCountToExpireDate()
        
        if (dayCount < 0) {
            message = "Expired"
        } else if (dayCount == 0) {
            message = "Expire today"
        } else if (dayCount == 1) {
            message = "Expire tomorrow"
        } else {
            message = "Expire in \(dayCount) days"
        }
        return message
    }
    
    func getAttributedDateString() -> NSAttributedString {
        let mediumAttr = [ NSAttributedString.Key.font: UIFont.init(name: "AvenirNext-Medium", size: 12)! ] as [NSAttributedString.Key : Any]
        let message = NSMutableAttributedString(string: "Added on ")
        message.append(NSAttributedString(string: getDateString(forDate: self.addDate!), attributes: mediumAttr))
        message.append(NSAttributedString(string: "\t\tWill expire on "))
        message.append(NSAttributedString(string: getDateString(forDate: self.expireDate!), attributes: mediumAttr))
        return message
    }
    
    private func getDateString(forDate date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
    
}
