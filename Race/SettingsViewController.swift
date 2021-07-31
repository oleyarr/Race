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
        
        if userDefaults.value(forKey: "driver name") == nil {
            driverNameTextField.text = ""
        } else {
            driverNameTextField.text = userDefaults.value(forKey: "driver name") as? String ?? ""
        }
        
        redButton.setTitleColor(.lightGray, for: .selected)
        redButton.setTitleColor(.red, for: .normal)
        blackButton.setTitleColor(.lightGray, for: .selected)
        blackButton.setTitleColor(.black, for: .normal)
        yellowButton.setTitleColor(.lightGray, for: .selected)
        yellowButton.setTitleColor(.yellow, for: .normal)
        
        let choosedCarColor = userDefaults.value(forKey: "car color") as? String ?? "red"
        selectCarColor(color: choosedCarColor)
    }
    
    @IBAction func redButtonPressed(_ sender: Any) {
        selectCarColor(color: "red")
    }
    
    @IBAction func yellowButtonPressed(_ sender: Any) {
        selectCarColor(color: "yellow")
    }
    
    @IBAction func blackButtonPressed(_ sender: Any) {
        selectCarColor(color: "black")    }
    
    @IBAction func driverNameEntered(_ sender: Any) {
        userDefaults.setValue(driverNameTextField.text, forKey: "driver name")
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
        userDefaults.setValue(color, forKey: "car color")
    }
}
