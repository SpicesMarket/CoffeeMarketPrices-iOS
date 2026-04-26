import Foundation
import Combine

struct PricesState: Equatable {
    var ui = PricesUIModel()
    var isLoading = false
}

typealias PricesMapping = @Sendable (PricesResponse) -> PricesUIModel

@MainActor
final class PricesViewModel: ObservableObject {
    @Published private(set) var state = PricesState()

    private let api: CoffeePricesAPI
    private let mapper: PricesMapping
    private var hasLoaded = false

    init(
        api: CoffeePricesAPI = LiveCoffeePricesAPI(),
        mapper: @escaping PricesMapping = PricesMapper.map
    ) {
        self.api = api
        self.mapper = mapper
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        await load()
    }

    func load() async {
        state.isLoading = true
        defer { state.isLoading = false }

        do {
            let response = try await api.fetchLatest()
            let mapper = self.mapper
            let ui = await Task.detached(priority: .userInitiated) {
                mapper(response)
            }.value
            state.ui = ui
            hasLoaded = true
        } catch {
            // Mirror Android behavior: silent failure, log only.
            print("CoffeePrices fetch failed: \(error)")
        }
    }
}
