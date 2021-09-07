//  GameSettings.swift
//  Lesson16_DZ_1
//
//  Created by Володя on 08.06.2021.
//

import Foundation

class ScoresList: Codable {
    var time: Date
    var driverName: String
    var carColor: String
    var score: Int

//    init(time: Date, driverName: String, carColor: String, scores: Int) {
    init(time: Date = Date(), driverName: String = "unknown", carColor: String = "black", scores: Int = 0) {
        self.time = time
        self.driverName = driverName
        self.carColor = carColor
        self.score = scores
    }
}
