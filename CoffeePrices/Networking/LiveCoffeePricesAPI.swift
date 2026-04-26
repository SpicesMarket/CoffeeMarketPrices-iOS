import Foundation
import Alamofire

nonisolated final class LiveCoffeePricesAPI: CoffeePricesAPI {
    private static let baseURL = "https://cropmarketprices-production.up.railway.app"
    private static let latestPath = "/prices/latest"

    private let session: Session
    private let decoder: JSONDecoder

    init() {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        self.decoder = decoder
    }

    func fetchLatest() async throws -> PricesResponse {
        try await session
            .request(Self.baseURL + Self.latestPath, method: .get)
            .validate()
            .serializingDecodable(PricesResponse.self, decoder: decoder)
            .value
    }
}
