import Foundation
import Testing
@testable import CoffeePrices

@Suite("PricesViewModel")
@MainActor
struct PricesViewModelTests {
    @Test("starts not loading with empty UI state")
    func initialState() {
        let vm = PricesViewModel(api: FakeCoffeePricesAPI())

        #expect(vm.state.isLoading == false)
        #expect(vm.state.ui.rows.isEmpty)
        #expect(vm.state.ui.lastUpdatedText == "Last Updated : --/--")
    }

    @Test("load() populates rows from the API and clears loading flag")
    func loadSuccessPopulatesRows() async {
        let api = FakeCoffeePricesAPI(result: .success(SampleData.canonicalResponse))
        let vm = PricesViewModel(api: api)

        await vm.load()

        #expect(vm.state.isLoading == false)
        #expect(vm.state.ui.rows.count == 5)
        #expect(api.fetchLatestCallCount == 1)
    }

    @Test("load() routes the response through the injected mapper")
    func loadUsesInjectedMapper() async {
        let api = FakeCoffeePricesAPI(result: .success(SampleData.canonicalResponse))
        let stubUI = PricesUIModel(
            rows: [PriceRowUI(id: "x", name: "Stub", cost: "₹0", trend: .up)],
            lastUpdatedText: "Last Updated : stub"
        )
        let vm = PricesViewModel(api: api, mapper: { _ in stubUI })

        await vm.load()

        #expect(vm.state.ui == stubUI)
    }

    @Test("load() leaves UI state untouched on failure")
    func loadFailureKeepsState() async {
        let api = FakeCoffeePricesAPI(result: .failure(URLError(.notConnectedToInternet)))
        let vm = PricesViewModel(api: api)

        await vm.load()

        #expect(vm.state.isLoading == false)
        #expect(vm.state.ui.rows.isEmpty)
        #expect(vm.state.ui.lastUpdatedText == "Last Updated : --/--")
    }

    @Test("loadIfNeeded() only fetches once after a successful load")
    func loadIfNeededIsIdempotent() async {
        let api = FakeCoffeePricesAPI(result: .success(SampleData.canonicalResponse))
        let vm = PricesViewModel(api: api)

        await vm.loadIfNeeded()
        await vm.loadIfNeeded()
        await vm.loadIfNeeded()

        #expect(api.fetchLatestCallCount == 1)
    }

    @Test("loadIfNeeded() retries while a previous attempt has failed")
    func loadIfNeededRetriesAfterFailure() async {
        let api = FakeCoffeePricesAPI(result: .failure(URLError(.timedOut)))
        let vm = PricesViewModel(api: api)

        await vm.loadIfNeeded()
        api.setResult(.success(SampleData.canonicalResponse))
        await vm.loadIfNeeded()

        #expect(api.fetchLatestCallCount == 2)
        #expect(vm.state.ui.rows.count == 5)
    }

    @Test("isLoading is true while the request is in flight")
    func isLoadingFlipsDuringFetch() async {
        let api = FakeCoffeePricesAPI(result: .success(SampleData.canonicalResponse))
        api.setDelay(.milliseconds(120))
        let vm = PricesViewModel(api: api)

        let task = Task { await vm.load() }

        // Yield enough times for the viewmodel's load() prologue to set
        // isLoading = true before the fake API's sleep returns.
        for _ in 0..<5 { await Task.yield() }
        try? await Task.sleep(for: .milliseconds(20))
        #expect(vm.state.isLoading == true)

        await task.value
        #expect(vm.state.isLoading == false)
        #expect(vm.state.ui.rows.count == 5)
    }
}
