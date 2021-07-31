import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var blackButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var chooseCarColorView: UIView!
    @IBOutlet weak var driverNameTextField: UITextField!
    
    private var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        redButton.setTitleColor(.lightGray, for: .selected)
        redButton.setTitleColor(.red, for: .normal)
        blackButton.setTitleColor(.lightGray, for: .selected)
        blackButton.setTitleColor(.black, for: .normal)
        yellowButton.setTitleColor(.lightGray, for: .selected)
        yellowButton.setTitleColor(.yellow, for: .normal)
        let choosedCarColor = userDefaults.value(forKey: "car color") as? String ?? "red"
        
        if userDefaults.value(forKey: "driver name") == nil {
            driverNameTextField.text = ""
        } else {
            driverNameTextField.text = userDefaults.value(forKey: "driver name") as? String ?? ""
        }
        
        switch choosedCarColor {
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
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        redButton.isSelected = true
        if redButton.isSelected {
            redButton.backgroundColor = .red
            blackButton.backgroundColor = .clear
            blackButton.isSelected = false
            yellowButton.backgroundColor = .clear
            yellowButton.isSelected = false
            userDefaults.setValue("red", forKey: "car color")
        }
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
        yellowButton.isSelected = true
        if yellowButton.isSelected {
            yellowButton.backgroundColor = .yellow
            redButton.backgroundColor = .clear
            redButton.isSelected = false
            blackButton.backgroundColor = .clear
            blackButton.isSelected = false
            userDefaults.setValue("yellow", forKey: "car color")
        }
    }
    
    @IBAction func blackButtonPressed(_ sender: Any) {
        blackButton.isSelected = true
        if blackButton.isSelected {
            blackButton.backgroundColor = .black
            redButton.backgroundColor = .clear
            redButton.isSelected = false
            yellowButton.backgroundColor = .clear
            yellowButton.isSelected = false
            userDefaults.setValue("black", forKey: "car color")
        }
    }
    
    @IBAction func driverNameEntered(_ sender: Any) {
        userDefaults.setValue(driverNameTextField.text, forKey: "driver name")
    }
}
