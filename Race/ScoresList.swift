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
    var scores: Int

    init(time: Date, driverName: String, carColor: String, scores: Int) {
        self.time = time
        self.driverName = driverName
        self.carColor = carColor
        self.scores = scores
    }
}
