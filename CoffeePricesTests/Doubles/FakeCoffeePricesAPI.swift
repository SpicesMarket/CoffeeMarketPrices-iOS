import Foundation
@testable import CoffeePrices

final class FakeCoffeePricesAPI: CoffeePricesAPI, @unchecked Sendable {
    private let lock = NSLock()
    private var _result: Result<PricesResponse, Error>
    private var _delay: Duration = .zero
    private var _calls = 0

    init(result: Result<PricesResponse, Error> = .success(PricesResponse(status: "success", data: []))) {
        self._result = result
    }

    var fetchLatestCallCount: Int {
        lock.withLock { _calls }
    }

    func setResult(_ result: Result<PricesResponse, Error>) {
        lock.withLock { _result = result }
    }

    func setDelay(_ delay: Duration) {
        lock.withLock { _delay = delay }
    }

    func fetchLatest() async throws -> PricesResponse {
        let (result, delay): (Result<PricesResponse, Error>, Duration) = lock.withLock {
            _calls += 1
            return (_result, _delay)
        }
        if delay > .zero {
            try? await Task.sleep(for: delay)
        }
        return try result.get()
    }
}
