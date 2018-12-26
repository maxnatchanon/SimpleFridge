//
//  Delay.swift
//  SimpleFridge
//
//  Created by Natchanon A. on 26/12/2561 BE.
//  Copyright © 2561 Natchanon A. All rights reserved.
//

import Foundation

func delay(for time: Double, execute: @escaping ()->Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + time) {
        execute()
    }
}
