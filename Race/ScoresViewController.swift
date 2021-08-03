import UIKit

class ScoresViewController: UIViewController {
    
    @IBOutlet weak var totalScoresLabel: UILabel!
    @IBOutlet weak var scoresTableView: UITableView!
    
    var userDefaults = UserDefaults.standard
    var gameScoresArray = [GameSettings()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"
        totalScoresLabel.text = "Total Scores: \(userDefaults.value(forKey: "Total scores") as? Int ?? 0)"
        gameScoresArray = decodeSettings()
        scoresTableView.dataSource = self
    }
    
    @IBAction func clearScoresButtonPressed(_ sender: Any) {
        userDefaults.setValue("0", forKey: "Total scores")
        userDefaults.setValue("", forKey: "list of session scores")
        totalScoresLabel.text = "Total Scores: 0"
        gameScoresArray.removeAll()
        userDefaults.setValue(gameScoresArray, forKey: "game_settings")
        scoresTableView.reloadData()
    }
    
    func decodeSettings() -> [GameSettings] {
        if let extractGameSettingsAsData = userDefaults.value(forKey: "game_settings") as? Data {
            let decoder = JSONDecoder()
            do {
                let settingsArray = try decoder.decode([GameSettings].self, from: extractGameSettingsAsData)
                gameScoresArray = settingsArray
            } catch {
                print(error.localizedDescription)
            }
        }
        return gameScoresArray
    }
}

extension ScoresViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameScoresArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let time = formatter.string(from: gameScoresArray[indexPath.row].time)
        let scores = String(gameScoresArray[indexPath.row].scores)
        let extractText =  "\(time):     \(scores)\n"
        cell.textLabel?.text = extractText
        return cell
    }
}
