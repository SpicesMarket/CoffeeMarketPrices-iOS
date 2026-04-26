import Foundation

nonisolated struct PricesResponse: Decodable, Sendable {
    let status: String
    let data: [PriceItem]
}
