import UIKit
import RealmSwift

class ScoresViewController: UIViewController {

    @IBOutlet weak var scoresTableView: UITableView!

    var userDefaults = UserDefaults.standard
    var scoresArray: [ScoresList] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"
        scoresArray = restoreScores()
        scoresTableView.dataSource = self
    }

    @IBAction func clearScoresButtonPressed(_ sender: Any) {
        scoresArray.removeAll()
        userDefaults.setValue(scoresArray, forKey: .scores)
        scoresTableView.reloadData()
    }

    func restoreScores() -> [ScoresList] {
        if let extractScoresData = userDefaults.value(forKey: .scores) as? Data {
            let decoder = JSONDecoder()
            do {
                let data = try decoder.decode([ScoresList].self, from: extractScoresData)
                scoresArray = data
            } catch {
                print(error.localizedDescription)
            }
        }
        return scoresArray
    }

    func saveScores(sessionScores: Int) {
        scoresArray = restoreScores()
        let driverName = userDefaults.value(forKey: .driverName) as? String ?? "noname"
        let carColor = userDefaults.value(forKey: .carColor) as? String ?? "red"
        let newScores = ScoresList(time: Date(),
                   driverName: driverName,
                   carColor: carColor,
                   scores: sessionScores)
        scoresArray.append(newScores)
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(scoresArray)
            userDefaults.setValue(data, forKey: .scores)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ScoresViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedScoresArray = scoresArray.sorted(by: { $0.scores > $1.scores })
        let cell = UITableViewCell()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd hh:mm"
        let time = formatter.string(from: sortedScoresArray[indexPath.row].time)
        let scores = String(sortedScoresArray[indexPath.row].scores)
        let driverName = String(sortedScoresArray[indexPath.row].driverName)
        let extractText =  "\(time):    \(driverName)    \(scores)\n"
        cell.textLabel?.text = extractText
        return cell
    }
}
