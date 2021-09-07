// как сделать обновление данные не по кнопке, а просто при переходе в Scores контроллер
// удаление и обновление данных на экране

import UIKit
import RxSwift
import RxCocoa

class RxScoresViewController: UIViewController {
    @IBOutlet weak var clearScoresButton: UIButton!
    @IBOutlet weak var scoresTableView: UITableView!
    @IBOutlet weak var refreshScoresButton: UIButton!

    var userDefaults = UserDefaults.standard
    let disposeBag = DisposeBag()
    private let viewModel = RxScoresViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scores"

        viewModel.dataSource
            .bind(to: scoresTableView.rx.items(cellIdentifier: RxScoresTableViewCell.identifier,
                                               cellType: RxScoresTableViewCell.self)) { index, model, cell in
            cell.configure(with: model)
            }
            .disposed(by: disposeBag)

        clearScoresButton
            .rx
            .tap
            .subscribe(onNext: { [weak self] in
                RealmManager.shared.clearAllScores()
                self?.viewModel.dataSource.onNext([]
                )
        }).disposed(by: disposeBag)

        let rxScores = convertRealmToRxArray()
        viewModel.dataSource.onNext(rxScores)
    }

    func saveScores(sessionScores: Int) {
        let driverName = userDefaults.value(forKey: .driverName) as? String ?? "noname"
        let carColor = userDefaults.value(forKey: .carColor) as? String ?? "red"
        let newScore = GameScores(time: Date(), driverName: driverName, carColor: carColor, scores: sessionScores)
        RealmManager.shared.addScore(newScore)
    }

    func convertRealmToRxArray() -> [RxScores] {
        let realmScores = RealmManager.shared.getAllScores()
        var rxScores: [RxScores] = []
        if realmScores.count > 0 {
            for index in 0...realmScores.count - 1 {
                rxScores.append(RxScores(time: realmScores[index].time,
                                         driverName: realmScores[index].driverName,
                                         carColor: realmScores[index].carColor,
                                         scores: realmScores[index].score ))
                }
        }
        let sortedrxScoresArray = rxScores.sorted(by: { $0.score > $1.score })
        return sortedrxScoresArray
    }
}
