//
//  RxScoresTableViewCell.swift
//  Race
//
//  Created by Володя on 03.09.2021.
//

import UIKit

class RxScoresTableViewCell: UITableViewCell {

    @IBOutlet weak var rxScoresLabel: UILabel!

    static let identifier = String(describing: RxScoresTableViewCell.self)
    let formatter = DateFormatter()

    func configure(with model: GameScores) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = formatter.string(from: model.time)
        let score = String(model.score)
        let driverName = String(model.driverName)
        let text = "\(score)    \(driverName)   \(time)"
        rxScoresLabel.text = text
    }
}
