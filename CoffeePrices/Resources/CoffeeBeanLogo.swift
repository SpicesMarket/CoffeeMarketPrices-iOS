import SwiftUI

struct CoffeeBeanLogo: View {
    var body: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                bean(size: size)
                    .rotationEffect(.degrees(-22))
                    .offset(x: -size * 0.10, y: -size * 0.06)
                bean(size: size)
                    .rotationEffect(.degrees(22))
                    .offset(x: size * 0.10, y: size * 0.06)
            }
            .frame(width: size, height: size)
            .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
        .accessibilityLabel("Coffee Prices logo")
    }

    @ViewBuilder
    private func bean(size: CGFloat) -> some View {
        let beanWidth = size * 0.55
        let beanHeight = size * 0.85
        let strokeWidth = size * 0.04
        let creaseWidth = size * 0.025

        ZStack {
            Capsule()
                .fill(Color.beanFill)
                .overlay(
                    Capsule()
                        .stroke(
                            Color.beanStroke,
                            style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round)
                        )
                )

            BeanCrease()
                .stroke(
                    Color.beanStroke,
                    style: StrokeStyle(lineWidth: creaseWidth, lineCap: .round)
                )
        }
        .frame(width: beanWidth, height: beanHeight)
    }
}

private struct BeanCrease: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY + rect.height * 0.10))
        path.addQuadCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY - rect.height * 0.10),
            control: CGPoint(x: rect.maxX - rect.width * 0.10, y: rect.midY)
        )
        return path
    }
}

#Preview {
    CoffeeBeanLogo()
        .frame(width: 160, height: 160)
        .padding()
        .background(Color.appBackground)
}
