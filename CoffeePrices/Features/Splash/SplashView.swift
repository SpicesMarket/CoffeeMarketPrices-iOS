import SwiftUI

struct SplashView: View {
    let logoNamespace: Namespace.ID
    @State private var logoOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            CoffeeBeanLogo()
                .matchedGeometryEffect(id: "appLogo", in: logoNamespace)
                .frame(width: 160, height: 160)
                .opacity(logoOpacity)
                .accessibilityLabel("Splash screen image")
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.6)) {
                logoOpacity = 1.0
            }
        }
    }
}

#Preview {
    SplashPreviewHost()
}

private struct SplashPreviewHost: View {
    @Namespace private var ns
    var body: some View { SplashView(logoNamespace: ns) }
}
