import UIKit

class ScoresViewController: UIViewController {

    @IBOutlet weak var scoresTableView: UITableView!

    var userDefaults = UserDefaults.standard
    var allScoresArray = RealmManager.shared.getAllScores()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"
        scoresTableView.dataSource = self
    }

    @IBAction func clearScoresButtonPressed(_ sender: Any) {
        RealmManager.shared.clearAllScores()
        scoresTableView.reloadData()
    }

    func saveScores(sessionScores: Int) {
        let driverName = userDefaults.value(forKey: .driverName) as? String ?? "noname"
        let carColor = userDefaults.value(forKey: .carColor) as? String ?? "red"
        let newScore = GameScores(time: Date(), driverName: driverName, carColor: carColor, scores: sessionScores)
        RealmManager.shared.addScore(newScore)
    }
}

extension ScoresViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allScoresArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedScoresArray = allScoresArray.sorted(by: { $0.score > $1.score })
        let cell = UITableViewCell()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = formatter.string(from: sortedScoresArray[indexPath.row].time)
        let scores = String(sortedScoresArray[indexPath.row].score)
        let driverName = String(sortedScoresArray[indexPath.row].driverName)
        let extractText =  "\(scores)    \(driverName)   \(time)"
        cell.textLabel?.text = extractText
        return cell
    }
}
