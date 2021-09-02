import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var driverNameTextField: UITextField!
    @IBOutlet weak var useGyroControl: UISwitch!

    private var userDefaults = UserDefaults.standard
    var isUseGyroControl: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"

        driverNameTextField.delegate = self
        if userDefaults.value(forKey: .driverName) == nil {
            driverNameTextField.text = ""
        } else {
            driverNameTextField.text = userDefaults.value(forKey: .driverName) as? String ?? ""
        }

        redButton.setTitleColor(.lightGray, for: .selected)
        redButton.setTitleColor(.red, for: .normal)
        blackButton.setTitleColor(.lightGray, for: .selected)
        blackButton.setTitleColor(.black, for: .normal)
        yellowButton.setTitleColor(.lightGray, for: .selected)
        yellowButton.setTitleColor(.yellow, for: .normal)

        let choosedCarColor = userDefaults.value(forKey: .carColor) as? String ?? "red"
        selectCarColor(color: choosedCarColor)

        restoreGyroControlSettings()
        useGyroControl.isOn = isUseGyroControl
    }

    @IBAction func redButtonPressed(_ sender: Any) {
        selectCarColor(color: "red")
    }

    @IBAction func yellowButtonPressed(_ sender: Any) {
        selectCarColor(color: "yellow")
    }

    @IBAction func blackButtonPressed(_ sender: Any) {
        selectCarColor(color: "black")    }

    @IBAction func useGyroControlButton(_ sender: Any) {
        isUseGyroControl = useGyroControl.isOn
        userDefaults.setValue(isUseGyroControl, forKey: "isUseGyroControl")
    }

    func selectCarColor(color: String) {
        switch color {
        case "red":
            redButton.isSelected  = true
            blackButton.isSelected  = false
            yellowButton.isSelected  = false
            redButton.backgroundColor = .red
            blackButton.backgroundColor = .clear
            yellowButton.backgroundColor = .clear
        case "yellow":
            yellowButton.isSelected = true
            redButton.isSelected  = false
            blackButton.isSelected  = false
            yellowButton.backgroundColor = .yellow
            redButton.backgroundColor = .clear
            blackButton.backgroundColor = .clear
        case "black":
            blackButton.isSelected = true
            yellowButton.isSelected  = false
            redButton.isSelected  = false
            blackButton.backgroundColor = .black
            redButton.backgroundColor = .clear
            yellowButton.backgroundColor = .clear
        default:
            redButton.isSelected  = true
            blackButton.isSelected  = false
            yellowButton.isSelected  = false
            redButton.backgroundColor = .red
            blackButton.backgroundColor = .clear
            yellowButton.backgroundColor = .clear
        }
        userDefaults.setValue(color, forKey: .carColor)
    }

    func restoreCarColorSettings() -> UIImage? {
        if userDefaults.value(forKey: .carColor) == nil {
            userDefaults.setValue("red", forKey: .carColor)
        }
        switch userDefaults.value(forKey: .carColor) as? String {
        case "red":
            return UIImage(named: "car_icon_red")
        case "black":
            return UIImage(named: "car_icon_black")
        case "yellow":
            return UIImage(named: "car_icon_yellow")
        default:
            return UIImage(named: "car_icon_red")
        }
    }

    func restoreGyroControlSettings() {
        if let control = userDefaults.value(forKey: "isUseGyroControl") as? Int {
            switch control {
            case 0: isUseGyroControl = false
            default: isUseGyroControl = true
            }
        }
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userDefaults.setValue(driverNameTextField.text, forKey: .driverName)
        driverNameTextField.resignFirstResponder()
        return true
    }
}
