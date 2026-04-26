import SwiftUI

struct PricesView: View {
    let logoNamespace: Namespace.ID
    @StateObject private var viewModel = PricesViewModel()

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 20)

                if viewModel.state.isLoading {
                    Spacer()
                    ProgressView()
                        .tint(Color.appAccent)
                    Spacer()
                } else {
                    list
                }
            }
        }
        .task { await viewModel.loadIfNeeded() }
    }

    private var header: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 2) {
                Text("Prices")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.appAccent)
                Text(viewModel.state.ui.lastUpdatedText)
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appAccent)
            }
            .frame(maxWidth: .infinity)

            HStack {
                CoffeeBeanLogo()
                    .matchedGeometryEffect(id: "appLogo", in: logoNamespace)
                    .frame(width: 44, height: 44)
                    .padding(.leading, 24)
                Spacer()
            }
        }
    }

    private var list: some View {
        List(viewModel.state.ui.rows) { row in
            PriceRowView(row: row)
                .listRowBackground(Color.appBackground)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
    }
}

#Preview {
    PricesPreviewHost()
}

private struct PricesPreviewHost: View {
    @Namespace private var ns
    var body: some View { PricesView(logoNamespace: ns) }
}
