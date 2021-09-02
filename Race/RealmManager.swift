import Foundation
import RealmSwift

class RealmManager {

    static let shared = RealmManager()

    private let realm: Realm!

    private init() {
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
            fatalError()
        }
    }

    func addScore(_ scores: GameScores) {
        do {
            try realm.write {
                realm.add(scores)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func getAllScores() -> Results<GameScores> {
        let gameScores = realm.objects(GameScores.self)
        return gameScores
    }

    func clearAllScores() {
        do {
            try realm.write({
                realm.deleteAll()
            })
        } catch {
            print(error.localizedDescription)
        }
    }
}
