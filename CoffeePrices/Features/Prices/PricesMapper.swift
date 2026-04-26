import Foundation

nonisolated enum PricesMapper {
    private static let lastUpdatedFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd MMM yyyy hh:mm a"
        return f
    }()

    static func map(_ response: PricesResponse) -> PricesUIModel {
        let sorted = response.data.sorted { $0.sortKey < $1.sortKey }

        let rows = sorted.map { item in
            PriceRowUI(
                id: item.id,
                name: item.spiceName,
                cost: item.spiceCost,
                trend: item.trend
            )
        }

        let lastUpdatedText: String
        if let date = sorted.first?.scrappedAt {
            lastUpdatedText = "Last Updated : \(lastUpdatedFormatter.string(from: date))"
        } else {
            lastUpdatedText = "Last Updated : --/--"
        }

        return PricesUIModel(rows: rows, lastUpdatedText: lastUpdatedText)
    }
}
