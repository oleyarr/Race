//
//  RxScoresViewModel.swift
//  Race
//
//  Created by Володя on 02.09.2021.
//

import Foundation
import RxSwift

class RxScoresViewModel {
    var dataSource = BehaviorSubject<[GameScores]>(value: [])
}
