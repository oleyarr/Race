import UIKit

class ScoresViewController: UIViewController {
    
    @IBOutlet weak var listOfScoresLabel: UILabel!
    @IBOutlet weak var totalScoresLabel: UILabel!
    @IBOutlet weak var scoresTableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    var gameSettingsArray = [GameSettings()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"
        totalScoresLabel.text = "Total Scores: \(userDefaults.value(forKey: "Total scores") as? Int ?? 0)"
        gameSettingsArray = decodeSettings()
        scoresTableView.dataSource = self
    }
    
    @IBAction func clearScoresButtonPressed(_ sender: Any) {
        userDefaults.setValue("0", forKey: "Total scores")
        userDefaults.setValue("", forKey: "list of session scores")
        totalScoresLabel.text = "Total Scores: 0"
        listOfScoresLabel.text = ""
        userDefaults.setValue([], forKey: "game_settings")
    }
    
    func decodeSettings() -> [GameSettings] {
        if let extractGameSettingsAsData = userDefaults.value(forKey: "game_settings") as? Data {
            let decoder = JSONDecoder()
            do {
                let settingsArray = try decoder.decode([GameSettings].self, from: extractGameSettingsAsData)
                gameSettingsArray = settingsArray
            }
            catch {
                print(error.localizedDescription)
            }
        }
        return gameSettingsArray
    }
}

extension ScoresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameSettingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let time = formatter.string(from: gameSettingsArray[indexPath.row].time)
        let scores = String(gameSettingsArray[indexPath.row].scores)
        let extractText =  "\(time):     \(scores)\n"
        cell.textLabel?.text = extractText
        return cell
    }
}
