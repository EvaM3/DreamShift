//
//  WishModel.swift
//  NightShift
//
//  Created by Eva Madarasz
//

import Foundation
import SwiftData

@Model
class Wish {
    var text: String
    var date: Date
    var tag: String

    init(text: String, date: Date = Date(), tag: String = "General") {
        self.text = text
        self.date = date
        self.tag = tag
    }
}

