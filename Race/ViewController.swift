import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonSettings: UIButton!
    @IBOutlet weak var buttonStart: UIButton!
    @IBOutlet weak var buttonScores: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Screen"
        buttonStart.addShadowToButtons()
        buttonScores.addShadowToButtons()
        buttonSettings.addShadowToButtons()
        colorTextStart()
        colorTextRandom(button: buttonSettings)
        colorTextRandom(button: buttonScores)
    }

    @IBAction func buttonStartPressed(_ sender: Any) {
        let gameViewController = ViewControllerFactory.shared.createGameViewController()
        navigationController?.pushViewController(gameViewController, animated: true)
    }
    
    @IBAction func buttonSettingsPressed(_ sender: Any) {
        let settingsViewController = ViewControllerFactory.shared.createSettingsViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    @IBAction func buttonScoresPressed(_ sender: Any) {
        let scoresViewController = ViewControllerFactory.shared.createScoresViewController()
        navigationController?.pushViewController(scoresViewController, animated: true)
    }
    
    func colorTextStart() {
        let attributedString = NSMutableAttributedString(string: "START")
        attributedString.addAttribute(.foregroundColor, value: UIColor.blue, range: NSRange(location: 2, length: 1))
        attributedString.addAttribute(.backgroundColor, value: UIColor.yellow, range: NSRange(location: 2, length: 1))
        attributedString.addAttribute(.font, value: UIFont.customFontOliandre(of: 40), range: NSRange(location: 0, length: 5))
        buttonStart.setAttributedTitle(attributedString, for: .normal)
    }
    
    func colorTextRandom(button: UIButton) {
        guard let text = button.currentTitle else {
            let text = ""
            return
        }
        var colors: [UIColor] = [.blue, .red, .green, .brown, .cyan, .magenta, .yellow, .black]
        let attributedString = NSMutableAttributedString(string: text)
        for (index, characters) in text.enumerated() {
            attributedString.addAttribute(.foregroundColor, value: colors.randomElement(), range: NSRange(location: index, length: 1))
            button.setAttributedTitle(attributedString, for: .normal)
        }
    }
}

extension UIView {
    func addShadowToButtons(shadowOpacity: Float = 0.7, shadowOffset: CGSize = .zero, shadowColor:  CGColor = UIColor.black.cgColor, shadowRadius: CGFloat = 10, cornerRadius: CGFloat  = 5) {
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowColor = shadowColor
        self.layer.shadowRadius = shadowRadius
        self.layer.cornerRadius = cornerRadius
    }
}
