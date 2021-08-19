//
//  UserDefaults+.swift
//  Race
//
//  Created by Володя on 05.08.2021.
//

import Foundation

extension UserDefaults {
    func setValue(_ value: Any?, forKey key: UserDefaultsKeys) {
        self.setValue(value, forKey: key.rawValue)
    }

    func value(forKey key: UserDefaultsKeys) -> Any? {
        return self.value(forKey: key.rawValue)
    }
}
