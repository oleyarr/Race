import UIKit
import CoreMotion

class GameViewController: UIViewController {

    @IBOutlet weak var carImageView: UIImageView!
    @IBOutlet weak var buttonRight: UIButton!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var liveScoresLabel: UILabel!

    var gamePlaceView = UIView()
    var greenViewLeft = UIView()
    var greenViewRight = UIView()
    var gameOverLabel = UILabel()

    var isCrash = false
    var isGameOver = false
    var carAnimationDuration = TimeInterval(0.04)
    var animateLaneStep: CGFloat = 12
    var laneTimer = Timer()
    var saveCarFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var carsArray = [UIImage(named: "yellow_car"),
                    UIImage(named: "red_car"),
                    UIImage(named: "black_car"),
                    UIImage(named: "pickup_car")]
    var countCarsPassedBy = 0 // сколько машин успешно проехало мимо
    var scoreStep = 1 // сколько очков добавлять единоразово
    var sessionScores = 0

    private var userDefaults = UserDefaults.standard
    let gyroMotionManager = CMMotionManager()
    let settings = SettingsViewController()

    override func viewWillAppear(_ animated: Bool) {
        createAndMoveFirstLongLane()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Тише едешь - дальше будешь"

        settings.restoreGyroControlSettings()
        if settings.isUseGyroControl {
            startGyroMotionManager()
        }

        initialButtonSettings()
        initialGreenViewSettings()
        sessionScores = 0
        liveUpdateTextLabelScores()

        let settingsViewController = SettingsViewController()
        carImageView.image = settingsViewController.restoreCarColorSettings()

        laneTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (_) in
            if !self.isGameOver {
                self.movingLane()
            }
        }

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            if !self.isGameOver {
                self.generateOncomingCars()
            }
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        isGameOver = true
    }

    @IBAction func buttonLeftPressed(_ sender: Any) {
        if !settings.isUseGyroControl {
            carImageView.frame.origin.x -= 20
            saveCarFrame = carImageView.frame
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.carImageView.transform = self.carImageView.transform.rotated(by: -0.3)
            } completion: { (_) in
                self.carImageView.transform = self.carImageView.transform.rotated(by: 0.3)
                self.carImageView.frame = self.saveCarFrame
                if self.carImageView.frame.intersects(self.greenViewLeft.frame) {
                    self.isCrash = true
                    self.gameOver()
                }
            }
        }
    }

    @IBAction func buttonRightPressed(_ sender: Any) {
        if !settings.isUseGyroControl {
            carImageView.frame.origin.x += 20
            saveCarFrame = carImageView.frame
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self.carImageView.transform = self.carImageView.transform.rotated(by: 0.3)
            } completion: { (_) in
                self.carImageView.transform = self.carImageView.transform.rotated(by: -0.3)
                self.carImageView.frame = self.saveCarFrame
                if self.carImageView.frame.intersects(self.greenViewRight.frame) {
                    self.isCrash = true
                    self.gameOver()
                }
            }
        }
    }

    func movingLane() {
        let roadLane = UIView()
        initialLaneSettings(roadLane)
        gamePlaceView.addSubview(roadLane)
        gamePlaceView.bringSubviewToFront(carImageView)
        animateLane(roadLane)
    }

    func animateLane(_ lane: UIView) {
        let newY = lane.frame.origin.y + animateLaneStep
        if lane.frame.minY >= self.gamePlaceView.frame.maxY {
            lane.removeFromSuperview()
        } else {
            UIView.animate(withDuration: carAnimationDuration, delay: 0, options: .curveLinear) {
                lane.frame.origin.y = newY
            } completion: { (_) in
                guard self.isCrash else {
                    self.animateLane(lane)
                    return
                }
            }
        }
    }

    func generateOncomingCars() {
        let car = UIImageView()
        initialOncomingCar(car)
        if let carImage = carsArray.randomElement() {
            car.image = carImage
        }
        gamePlaceView.addSubview(car)
        animateOneCar(car)
    }

    func animateOneCar(_ car: UIView) {
        let newY = car.frame.origin.y + animateLaneStep * CGFloat.random(in: 1.3...1.5)
        if newY > gamePlaceView.frame.maxY {
            countCarsPassedBy += 1
            sessionScores += scoreStep
            liveUpdateTextLabelScores()
            return
        }
        UIView.animate(withDuration: carAnimationDuration, delay: 0, options: .curveLinear) {
            if self.isCrash {
                return
            } else {
                car.frame.origin.y = newY
            }
        } completion: { (_) in
            if car.frame.intersects(self.carImageView.frame) {
                self.isCrash = true
                self.gameOver()
            } else {
                self.animateOneCar(car)
            }
        }
    }

    func gameOver() {
        isGameOver = true
        if settings.isUseGyroControl {
            stopGyroMotionManager()
        }
        liveUpdateTextLabelScores()
        let scoresViewController = ScoresViewController()
        scoresViewController.saveScores(sessionScores: sessionScores)
        initGameOverLabel()
    }

    func liveUpdateTextLabelScores() {
        liveScoresLabel.text = "\(sessionScores)"
    }
}
