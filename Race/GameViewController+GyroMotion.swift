//
//  GameViewController+GyroMotion.swift
//  Race
//
//  Created by Володя on 05.08.2021.
//

import UIKit

extension GameViewController {

    func startGyroMotionManager() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
        } completion: { (_) in
            if self.gyroMotionManager.isGyroAvailable {
                self.gyroMotionManager.gyroUpdateInterval = 1 / 60
                self.gyroMotionManager.startGyroUpdates(to: .main) { (data, error) in
                    if let error = error {
                        print("error = ", error.localizedDescription)
                        return
                    }
                    if let gyroData = data {
                        self.carImageView.frame.origin.x += (CGFloat(gyroData.rotationRate.y) * 2)
                        self.carImageView.frame.origin.y +=  (CGFloat(gyroData.rotationRate.x ))
                    }
                    if self.carImageView.frame.intersects(self.greenViewRight.frame)
                        || self.carImageView.frame.intersects(self.greenViewLeft.frame) {
                        self.isCrash = true
                        self.gameOver()
                    }
                }
            }
        }
    }

    func stopGyroMotionManager() {
        gyroMotionManager.stopGyroUpdates()
    }
}
