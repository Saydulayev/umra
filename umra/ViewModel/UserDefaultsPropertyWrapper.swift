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
            // Поддержка RawRepresentable типов (например, enum с String)
            if let rawRepresentableType = T.self as? any RawRepresentable.Type,
               let rawValue = userDefaults.string(forKey: key) {
                // Пытаемся создать значение из rawValue
                if let value = rawRepresentableType.init(rawValue: rawValue as! rawRepresentableType.RawValue) as? T {
                    return value
                }
            }
            
            // Поддержка Bool
            if T.self == Bool.self {
                // Проверяем, есть ли значение в UserDefaults
                if userDefaults.object(forKey: key) != nil {
                    return userDefaults.bool(forKey: key) as! T
                }
                return defaultValue
            }
            
            // Поддержка String
            if T.self == String.self {
                return (userDefaults.string(forKey: key) ?? defaultValue as! String) as! T
            }
            
            // Поддержка CGFloat
            if T.self == CGFloat.self {
                if let value = userDefaults.object(forKey: key) as? CGFloat {
                    return value as! T
                }
                return defaultValue
            }
            
            // Для других типов пытаемся получить как объект
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
            
            // Поддержка Bool
            if let boolValue = newValue as? Bool {
                userDefaults.set(boolValue, forKey: key)
                return
            }
            
            // Поддержка String
            if let stringValue = newValue as? String {
                userDefaults.set(stringValue, forKey: key)
                return
            }
            
            // Поддержка CGFloat
            if let cgFloatValue = newValue as? CGFloat {
                userDefaults.set(cgFloatValue, forKey: key)
                return
            }
            
            // Для других типов сохраняем как объект
            userDefaults.set(newValue, forKey: key)
        }
    }
}
