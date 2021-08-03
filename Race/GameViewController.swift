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
    var animateLaneStep: CGFloat = 13
    var laneTimer = Timer()
    var saveCarFrame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var carArray = [UIImage(named: "yellow_car"),
                    UIImage(named: "red_car"),
                    UIImage(named: "black_car"),
                    UIImage(named: "pickup_car")]
    var countCarsPassedBy = 0 // сколько машин успешно проехало мимо
    var crashPenalty = 0 // сколько очков вычитать за аварию
    var scoreStep = 1 // сколько очков добавлять единоразово
    var totalScores = 0
    var sessionScores = 0
    var listOfSessionScores: String = ""

    private var userDefaults = UserDefaults.standard
    private var fileManager = FileManager.default
    private lazy var cacheFolderURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    private lazy var savedScoresURL = cacheFolderURL.appendingPathComponent("SavedScores")
    var motionManager = CMMotionManager()

    override func viewWillAppear(_ animated: Bool) {
        createAndMoveFirstLongLane()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Тише едешь - дальше будешь"
        laneTimer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (_) in
            if !self.isGameOver {
                self.movingLane()
            }
        }
        sessionScores = 0
        totalScores = userDefaults.value(forKey: "Total scores") as? Int ?? 0
        if let listOfSessionScores1 = userDefaults.value(forKey: "list of session scores") as? String {
            listOfSessionScores = listOfSessionScores1
        } else {
            listOfSessionScores = "\n"
        }
        buttonLeft.layer.borderColor = UIColor.green.cgColor
        buttonLeft.layer.borderWidth = 0.5
        buttonRight.layer.borderColor = UIColor.green.cgColor
        buttonRight.layer.borderWidth = 0.5
        gamePlaceView.frame = view.frame
        gamePlaceView.frame.size.height = view.frame.maxY + 20
        gamePlaceView.backgroundColor = .gray
        gamePlaceView.clipsToBounds = true
        view.addSubview(gamePlaceView)

        switch userDefaults.value(forKey: "car color") as? String ?? "red" {
        case "red":
            carImageView.image = UIImage(named: "car_icon_red")
        case "black":
            carImageView.image = UIImage(named: "car_icon_black")
        case "yellow":
            carImageView.image = UIImage(named: "car_icon_yellow")
        default:
            carImageView.image = UIImage(named: "car_icon_red")
        }

        initialGreenViewSettings()
        liveUpdateTextLabelScores()

        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (_) in
            if !self.isGameOver {
                self.generateOncomingCars()
            }
        }
        moveCarByMovingPhone()
    }

    override func viewDidDisappear(_ animated: Bool) {
        isGameOver = true
    }

    @IBAction func buttonLeftPressed(_ sender: Any) {
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

    @IBAction func buttonRightPressed(_ sender: Any) {
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

    func moveCarByMovingPhone() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear) {
        } completion: { (_) in
            if self.motionManager.isGyroAvailable {
                self.motionManager.gyroUpdateInterval = 1 / 60
                self.motionManager.startGyroUpdates(to: .main) { (data, error) in
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

    func movingLane() {
        let roadLane = UIView()
        initLane(roadLane)
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

    func initLane(_ lane: UIView) {
        lane.frame.size.width = gamePlaceView.frame.width / 30
        lane.frame.size.height = gamePlaceView.frame.height / 15
        lane.frame.origin.y = 0 // -lane.frame.size.height
        lane.frame.origin.x = gamePlaceView.center.x - lane.frame.width / 2
        lane.backgroundColor = .white
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

    func generateOncomingCars() {
        let car = UIImageView()
        oncomingCarInit(car)
        if let carImage = carArray.randomElement() {
            car.image = carImage
        }
        gamePlaceView.addSubview(car)
        animateOneCar(car)
    }

    func animateOneCar(_ car: UIView) {
        let newY = car.frame.origin.y + animateLaneStep * CGFloat.random(in: 1.2...1.5)
        if newY > gamePlaceView.frame.maxY {
            countCarsPassedBy += 1
            totalScores += scoreStep
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

    func oncomingCarInit(_ car: UIImageView) {
        car.frame.size.width = gamePlaceView.frame.width / 11
        car.frame.size.height = gamePlaceView.frame.height / 11
        car.frame.origin.y = -car.frame.size.height
        car.frame.origin.x = CGFloat.random(
            in: self.gamePlaceView.frame.minX + 70...self.gamePlaceView.frame.maxX - 70 - car.frame.width)
        car.backgroundColor = .clear
    }

    func gameOver() {
        isGameOver = true
        motionManager.stopGyroUpdates()
        if isCrash {
            totalScores -= crashPenalty
            sessionScores -= crashPenalty
        }
//        totalScores += sessionScores
        liveUpdateTextLabelScores()
        userDefaults.setValue(totalScores, forKey: "Total scores")
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = formatter.string(from: currentDate)
        userDefaults.setValue(
            "\(dateString):    \(String(sessionScores))\n\(listOfSessionScores)", forKey: "list of session scores")
        saveScoresToFile(dateString: dateString)
        saveAllSettings()
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

    func liveUpdateTextLabelScores() {
        liveScoresLabel.text = "\(sessionScores)"
    }

    func saveScoresToFile(dateString: String) {
        let scores = dateString + "    " + String(sessionScores)
        if fileManager.fileExists(atPath: savedScoresURL.path) {
            do {
                var lastString = try String(contentsOf: savedScoresURL)
                lastString = scores + "\n" + lastString
                try lastString.write(toFile: savedScoresURL.path, atomically: true, encoding: .utf8)
            } catch {
                print(error.localizedDescription)
            }
        } else {
            fileManager.createFile(atPath: savedScoresURL.path, contents: scores.data(using: .utf8), attributes: [:])
        }
    }

    func saveAllSettings() {
        let gameSettings = GameSettings()
        var gameSettingsArray = [gameSettings]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        //        тут надо достать из настроек предыдущие настройки
        if let extractGameSettingsAsData = userDefaults.value(forKey: "game_settings") as? Data {
            let decoder = JSONDecoder()
            do {
                let settingsArray = try decoder.decode([GameSettings].self, from: extractGameSettingsAsData)
                gameSettingsArray = settingsArray
            } catch {
                print(error.localizedDescription)
            }
        }
        //        добавить в массив новый набор настроек
        gameSettings.time = Date()
        gameSettings.carColor = userDefaults.value(forKey: "car color") as? String ?? ""
        gameSettings.driverName = userDefaults.value(forKey: "driver name") as? String ?? ""
        gameSettings.scores = sessionScores
        gameSettingsArray.append(gameSettings)
        //        сохранить массив обратно в настройки
        let encoder  = JSONEncoder()
        let gameSettingsData = try? encoder.encode(gameSettingsArray)
        userDefaults.setValue(gameSettingsData, forKey: "game_settings")
    }
}
