//
//  GameViewController+SetupViews.swift
//  Race
//
//  Created by Володя on 05.08.2021.
//

import UIKit

extension GameViewController {

    func initialButtonSettings() {
        buttonLeft.layer.borderColor = UIColor.green.cgColor
        buttonLeft.layer.borderWidth = 0.5
        buttonRight.layer.borderColor = UIColor.green.cgColor
        buttonRight.layer.borderWidth = 0.5
        gamePlaceView.frame = view.frame
        gamePlaceView.frame.size.height = view.frame.maxY + 20
        gamePlaceView.backgroundColor = .gray
        gamePlaceView.clipsToBounds = true
        view.addSubview(gamePlaceView)
    }

    func initialLaneSettings(_ lane: UIView) {
        lane.frame.size.width = gamePlaceView.frame.width / 30
        lane.frame.size.height = gamePlaceView.frame.height / 15
        lane.frame.origin.y = 0 // -lane.frame.size.height
        lane.frame.origin.x = gamePlaceView.center.x - lane.frame.width / 2
        lane.backgroundColor = .white
    }

    func initialGreenViewSettings() {
        carImageView.frame.origin.y = gamePlaceView.frame.maxY - 150
        carImageView.frame.size = CGSize(width: gamePlaceView.frame.width / 14, height: gamePlaceView.frame.height / 11)
        carImageView.frame.origin.x = gamePlaceView.center.x - carImageView.frame.width / 2
        carImageView.contentMode = .scaleToFill
        carImageView.backgroundColor = .clear
        gamePlaceView.addSubview(carImageView)
        saveCarFrame = carImageView.frame

        greenViewLeft.frame = gamePlaceView.frame
        greenViewLeft.frame.size.width = 70
        greenViewLeft.backgroundColor = .systemGreen
        greenViewLeft.layer.borderWidth = 4
        greenViewLeft.layer.borderColor = UIColor.white.cgColor
        gamePlaceView.addSubview(greenViewLeft)

        greenViewRight.frame = gamePlaceView.frame
        greenViewRight.frame.size.width = 70
        greenViewRight.frame.origin.x = gamePlaceView.frame.width - greenViewRight.frame.width
        greenViewRight.backgroundColor = .systemGreen
        greenViewRight.layer.borderWidth = 4
        greenViewRight.layer.borderColor = UIColor.white.cgColor
        gamePlaceView.addSubview(greenViewRight)

        view.bringSubviewToFront(buttonLeft)
        view.bringSubviewToFront(buttonRight)
        view.bringSubviewToFront(liveScoresLabel)
    }

    func initGameOverLabel() {
            gameOverLabel.backgroundColor = .black.withAlphaComponent(0.5)
            gameOverLabel.frame = self.gamePlaceView.frame
            gameOverLabel.frame.origin.y = gameOverLabel.frame.height / 8 - gameOverLabel.frame.height / 16 - 50
            gameOverLabel.numberOfLines = 0
            gameOverLabel.text = "Game Over!\n your score is \(sessionScores)"
            gameOverLabel.textColor = .white
            gameOverLabel.textAlignment = .center
            gameOverLabel.font = UIFont.systemFont(ofSize: 50)
            view.addSubview(gameOverLabel)
            view.bringSubviewToFront(gameOverLabel)
    }

    func createAndMoveFirstLongLane() {
        let lane = UIView()
        gamePlaceView.addSubview(lane)
        lane.frame.size.width = gamePlaceView.frame.width / 30
        lane.frame.size.height = gamePlaceView.frame.height
        lane.frame.origin.y = 0
        lane.frame.origin.x = gamePlaceView.center.x - lane.frame.width / 2
        lane.backgroundColor = .white
        UIView.animate(
            withDuration: TimeInterval(self.gamePlaceView.frame.height / animateLaneStep) * carAnimationDuration,
            delay: 0,
            options: .curveLinear) {
            lane.frame.origin.y = self.gamePlaceView.frame.height
        } completion: { (_) in
        }
    }
    
    func initialOncomingCar(_ car: UIImageView) {
        car.frame.size.width = gamePlaceView.frame.width / 11
        car.frame.size.height = gamePlaceView.frame.height / 11
        car.frame.origin.y = -car.frame.size.height
        car.frame.origin.x = CGFloat.random(
            in: self.gamePlaceView.frame.minX + 70...self.gamePlaceView.frame.maxX - 70 - car.frame.width)
        car.backgroundColor = .clear
    }

}
