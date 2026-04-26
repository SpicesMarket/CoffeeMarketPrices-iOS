import Foundation

nonisolated protocol CoffeePricesAPI: Sendable {
    func fetchLatest() async throws -> PricesResponse
}
