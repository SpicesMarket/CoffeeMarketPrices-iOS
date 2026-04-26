import Foundation
@testable import CoffeePrices

enum SampleData {
    static let canonicalJSON: Data = {
        let raw = #"""
        {
          "status": "success",
          "data": [
            { "_id": "1", "spiceName": "Arabica Parchment", "spiceCost": "₹27,000-28,000", "average": 27500, "status": 0,  "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z", "priority": 1 },
            { "_id": "2", "spiceName": "Arabica Cherry",    "spiceCost": "₹14,000-16,300", "average": 15150, "status": 1,  "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z", "priority": 2 },
            { "_id": "3", "spiceName": "Robusta Parchment", "spiceCost": "₹17,500-18,500", "average": 18000, "status": -1, "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z", "priority": 3 },
            { "_id": "4", "spiceName": "Robusta Cherry",    "spiceCost": "₹11,500-12,750", "average": 12125, "status": 0,  "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z", "priority": 4 },
            { "_id": "5", "spiceName": "Pepper",            "spiceCost": "₹675",          "average": 675,   "status": 0,  "priceDiff": 0, "scrappedAt": "2025-09-15T22:45:21.821Z" }
          ]
        }
        """#
        return Data(raw.utf8)
    }()

    static let canonicalResponse: PricesResponse = decode(canonicalJSON)

    static func decode(_ data: Data) -> PricesResponse {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        return try! decoder.decode(PricesResponse.self, from: data)
    }
}
