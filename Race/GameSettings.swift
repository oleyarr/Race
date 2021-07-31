//  GameSettings.swift
//  Lesson16_DZ_1
//
//  Created by Володя on 08.06.2021.
//

import Foundation

class GameSettings: Codable {
    var time = Date()
    var driverName: String = ""
    var carColor: String = ""
    var scores: Int = 0
}
