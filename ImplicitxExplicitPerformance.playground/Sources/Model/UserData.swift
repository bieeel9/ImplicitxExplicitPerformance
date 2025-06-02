//
//  UserData.swift
//  
//
//  Created by Gabriel Santos on 02/06/25.
//

import Foundation

public struct UserData {
    public let id: Int
    public let name: String
    public let profile: Profile
    public let settings: Settings
    public let activity: Activity
}

public struct Profile {
    public let email: String
    public let phone: String
    public let address: Address
}

public struct Address {
    public let street: String
    public let city: String
    public let zipCode: String
}

public struct Settings {
    public let notificationsEnabled: Bool
    public let theme: String
    public let preferences: Preferences
}

public struct Preferences {
    public let language: String
    public let fontSize: Double
    public let layout: String
}

public struct Activity {
    public let lastLogin: Date
    public let actions: [String]
}
