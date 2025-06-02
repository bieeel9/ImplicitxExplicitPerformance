import Foundation

// MARK: - Run Test

func runInitializationTest(iterations: Int = 100000) {
    print("Running with \(iterations) iterations...\n")

    let explicitTime = measureTime(label: "Explicit Declaration") {
        for i in 0..<iterations {
            let user: UserData = makeSampleUser(id: i)
            _ = user
        }
    }

    let implicitTime = measureTime(label: "Implicit Declaration") {
        for i in 0..<iterations {
            let user = makeSampleUser(id: i)
            _ = user
        }
    }

    let diff = explicitTime - implicitTime
    print("\nDifference (explicit - implicit): \(diff) seconds")
}

runInitializationTest()
