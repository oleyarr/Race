import UIKit

class ViewControllerFactory {

    static let shared = ViewControllerFactory()

    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    private init () {}

    func createViewController() -> ViewController {
        return storyboard.instantiateViewController(identifier: "ViewController") // as ViewController
    }

    func createGameViewController() -> GameViewController {
        return storyboard.instantiateViewController(identifier: "GameViewController") // as GameViewController
    }

    func createSettingsViewController() -> SettingsViewController {
        return storyboard.instantiateViewController(identifier: "SettingsViewController") // as SettingsViewController
    }

    func createScoresViewController() -> ScoresViewController {
         return storyboard.instantiateViewController(identifier: "ScoresViewController") // as ScoresViewController
    }

    func createRxScoresViewController() -> RxScoresViewController {
         return storyboard.instantiateViewController(identifier: "RxScoresViewController") // as ScoresViewController
    }

}
