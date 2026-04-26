import Foundation

nonisolated struct PriceRowUI: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let cost: String
    let trend: Trend
}

nonisolated struct PricesUIModel: Equatable, Sendable {
    var rows: [PriceRowUI] = []
    var lastUpdatedText: String = "Last Updated : --/--"
}
