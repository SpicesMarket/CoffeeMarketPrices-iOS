import Foundation

nonisolated struct PriceItem: Decodable, Identifiable, Hashable, Sendable {
    let id: String
    let spiceName: String
    let spiceCost: String
    let average: Int
    let status: Int
    let priceDiff: Int?
    let scrappedAt: Date?
    let priority: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case spiceName, spiceCost, average, status, priceDiff, scrappedAt, priority
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let name = try c.decode(String.self, forKey: .spiceName)
        self.spiceName = name
        self.id = (try? c.decode(String.self, forKey: .id)) ?? name
        self.spiceCost = try c.decode(String.self, forKey: .spiceCost)
        self.average = (try? c.decode(Int.self, forKey: .average)) ?? 0
        self.status = (try? c.decode(Int.self, forKey: .status)) ?? 0
        self.priceDiff = try? c.decode(Int.self, forKey: .priceDiff)
        self.scrappedAt = try? c.decode(Date.self, forKey: .scrappedAt)
        self.priority = try? c.decode(Int.self, forKey: .priority)
    }

    var sortKey: Int { priority ?? -1 }
    var trend: Trend { Trend(rawStatus: status) }
}

nonisolated enum Trend: Sendable {
    case up, down, unchanged

    init(rawStatus: Int) {
        switch rawStatus {
        case 1: self = .up
        case -1: self = .down
        default: self = .unchanged
        }
    }
}
