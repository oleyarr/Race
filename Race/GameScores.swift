//
//  Scores.swift
//  Race
//
//  Created by Володя on 22.08.2021.
//
import RealmSwift

class GameScores: Object {
    @Persisted var time: Date
    @Persisted var driverName: String
    @Persisted var carColor: String
    @Persisted var score: Int

    convenience init(time: Date, driverName: String, carColor: String, scores: Int) {
        self.init()
        self.time = time
        self.driverName = driverName
        self.carColor = carColor
        self.score = scores
    }
}
