//
//  UserDefaultsPropertyWrapper.swift
//  umra
//
//  Created for modern Swift property wrapper
//

import Foundation

/// Property wrapper для автоматического сохранения и загрузки значений из UserDefaults
/// Поддерживает RawRepresentable типы (enum с String), Bool, String, CGFloat
@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    private let userDefaults: UserDefaults

    init(key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            // Поддержка RawRepresentable типов (например, enum с String или Int)
            if let rawRepresentableType = T.self as? any RawRepresentable.Type {
                if let rawString = userDefaults.string(forKey: key),
                   let typedRaw = rawString as? rawRepresentableType.RawValue,
                   let value = rawRepresentableType.init(rawValue: typedRaw) as? T {
                    return value
                }
                return defaultValue
            }

            // Поддержка Bool
            if T.self == Bool.self {
                guard userDefaults.object(forKey: key) != nil else { return defaultValue }
                return (userDefaults.bool(forKey: key) as? T) ?? defaultValue
            }

            // Поддержка String
            if T.self == String.self {
                return (userDefaults.string(forKey: key) as? T) ?? defaultValue
            }

            // Поддержка CGFloat — хранится как Double в UserDefaults
            if T.self == CGFloat.self {
                guard userDefaults.object(forKey: key) != nil else { return defaultValue }
                return (CGFloat(userDefaults.double(forKey: key)) as? T) ?? defaultValue
            }

            return userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Поддержка RawRepresentable типов
            if let rawRepresentable = newValue as? any RawRepresentable {
                let rawValue = rawRepresentable.rawValue
                if let stringValue = rawValue as? String {
                    userDefaults.set(stringValue, forKey: key)
                } else if let intValue = rawValue as? Int {
                    userDefaults.set(intValue, forKey: key)
                }
                return
            }

            if let boolValue = newValue as? Bool {
                userDefaults.set(boolValue, forKey: key)
                return
            }

            if let stringValue = newValue as? String {
                userDefaults.set(stringValue, forKey: key)
                return
            }

            // CGFloat сохраняем явно как Double для надёжного чтения
            if let cgFloatValue = newValue as? CGFloat {
                userDefaults.set(Double(cgFloatValue), forKey: key)
                return
            }

            userDefaults.set(newValue, forKey: key)
        }
    }
}
