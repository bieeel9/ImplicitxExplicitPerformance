//
//  Helper.swift
//  
//
//  Created by Gabriel Santos on 02/06/25.
//

import Foundation

// MARK: - Sample Data Generator

public func makeSampleUser(id: Int) -> UserData {
    return UserData(
        id: id,
        name: "User \(id)",
        profile: Profile(
            email: "user\(id)@example.com",
            phone: .random(),
            address: Address(
                street: .random(),
                city: .random(),
                zipCode: .random()
            )
        ),
        settings: Settings(
            notificationsEnabled: true,
            theme: .random(),
            preferences: Preferences(
                language: .random(),
                fontSize: 14.0,
                layout: .random()
            )
        ),
        activity: Activity(
            lastLogin: Date(),
            actions: Array(repeating: .random(), count: 20)
        )
    )
}

// MARK: - Performance Measurement Utility

public func measureTime(label: String, block: () -> Void) -> TimeInterval {
    let start = CFAbsoluteTimeGetCurrent()
    block()
    let end = CFAbsoluteTimeGetCurrent()
    let elapsed = end - start
    print("\(label): \(elapsed) seconds")
    return elapsed
}

// MARK: - Random

extension String {
    
    static func random() -> String {
        let range = (0..<10)
        let characterSetString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
        return String(range.map { _ in characterSetString.randomElement() ?? "A" })
    }
}
