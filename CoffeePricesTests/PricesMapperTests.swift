import Foundation
import Testing
@testable import CoffeePrices

@Suite("PricesMapper")
struct PricesMapperTests {
    @Test("maps DTO fields to UI fields")
    func mapsDtoFields() {
        let ui = PricesMapper.map(SampleData.canonicalResponse)

        #expect(ui.rows.count == 5)
        let arabicaParchment = ui.rows.first { $0.id == "1" }
        #expect(arabicaParchment?.name == "Arabica Parchment")
        #expect(arabicaParchment?.cost == "₹27,000-28,000")
        #expect(arabicaParchment?.trend == .unchanged)
    }

    @Test("translates status int to Trend enum")
    func translatesTrendStatus() {
        let ui = PricesMapper.map(SampleData.canonicalResponse)

        #expect(ui.rows.first(where: { $0.id == "2" })?.trend == .up)
        #expect(ui.rows.first(where: { $0.id == "3" })?.trend == .down)
        #expect(ui.rows.first(where: { $0.id == "5" })?.trend == .unchanged)
    }

    @Test("sorts by priority ascending; missing priority sorts to top as -1")
    func sortsByPriority() {
        let ui = PricesMapper.map(SampleData.canonicalResponse)

        // Pepper has no priority => sortKey = -1, so it should come first.
        #expect(ui.rows.first?.name == "Pepper")
        #expect(ui.rows.map(\.name) == [
            "Pepper",
            "Arabica Parchment",
            "Arabica Cherry",
            "Robusta Parchment",
            "Robusta Cherry",
        ])
    }

    @Test("formats lastUpdatedText with dd MMM yyyy hh:mm a")
    func formatsLastUpdated() {
        let ui = PricesMapper.map(SampleData.canonicalResponse)

        // 2025-09-15T22:45:21.821Z -> regex check on the format pattern.
        // The displayed date is in the device-local time zone, so we don't
        // assert exact wall-clock — only the format shape.
        let pattern = #"^Last Updated : \d{2} [A-Za-z]{3} \d{4} \d{2}:\d{2} (AM|PM)$"#
        #expect(ui.lastUpdatedText.range(of: pattern, options: .regularExpression) != nil,
                "Expected formatted date, got \(ui.lastUpdatedText)")
    }

    @Test("missing date falls back to placeholder")
    func placeholderWhenEmpty() {
        let empty = PricesResponse(status: "success", data: [])
        let ui = PricesMapper.map(empty)

        #expect(ui.rows.isEmpty)
        #expect(ui.lastUpdatedText == "Last Updated : --/--")
    }
}
