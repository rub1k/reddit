//
//  AuthStorage.swift
//  RedditClient
//
//  Created by Ruba Vitalii on 22.09.2020.
//

import Foundation

protocol AuthStorable {
    var isTokenPresent: Bool { get }
    var token: String? { get }
    var isExpire: Bool { get }

    func saveToken(_ token: String, expireAfter time: TimeInterval)
    func removeToken()
}

struct AuthNotification {
    static let didAuthorize = Notification.Name(rawValue: "UserDidAuthorizeNotification")
    static let didUnathorize = Notification.Name(rawValue: "UserDidUnauthorizeNotification")
}

class AuthStorage: AuthStorable {
    private struct Keys {
        static let token = "token.storage.key"
        static let expire = "expire.storage.key"
    }

    private let dataSaver: DataSavable
    private let notificationCenter = NotificationCenter.default

    init(dataSaver: DataSavable) {
        self.dataSaver = dataSaver
    }

    var isTokenPresent: Bool {
        return token != nil
    }

    var token: String? {
        set {
            dataSaver.set(newValue, forKey: Keys.token)
        }
        get {
            dataSaver.string(forKey: Keys.token)
        }
    }

    var isExpire: Bool {
        let expireDate = dataSaver.double(forKey: Keys.expire)
        return expireDate <= Date().timeIntervalSince1970
    }

    func saveToken(_ token: String, expireAfter time: TimeInterval) {
        self.token = token
        let expireTime = time + Date().timeIntervalSince1970
        dataSaver.set(expireTime, forKey: Keys.expire)
        notificationCenter.post(name: AuthNotification.didAuthorize, object: nil)
    }

    func removeToken() {
        token = nil
        notificationCenter.post(name: AuthNotification.didUnathorize, object: nil)
    }
}

protocol DataSavable {
    func string(forKey defaultName: String) -> String?
    func double(forKey defaultName: String) -> Double
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: DataSavable {}
