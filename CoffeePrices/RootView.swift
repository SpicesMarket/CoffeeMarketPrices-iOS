import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @Namespace private var logoNamespace

    var body: some View {
        ZStack {
            if showSplash {
                SplashView(logoNamespace: logoNamespace)
                    .transition(.opacity)
            } else {
                PricesView(logoNamespace: logoNamespace)
                    .transition(.opacity)
            }
        }
        .task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            withAnimation(.easeInOut(duration: 0.55)) {
                showSplash = false
            }
        }
    }
}

#Preview {
    RootView()
}
