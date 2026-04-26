import SwiftUI

struct PriceRowView: View {
    let row: PriceRowUI

    var body: some View {
        HStack(spacing: 0) {
            Text(row.name)
                .font(.system(size: 16))
                .foregroundStyle(Color.appAccent)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            trendArrow
                .frame(width: 24)

            Text(row.cost)
                .font(.system(size: 16))
                .foregroundStyle(Color.appAccent)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .frame(height: 100)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
    }

    @ViewBuilder
    private var trendArrow: some View {
        switch row.trend {
        case .up:
            Image(systemName: "arrowtriangle.up.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 11, height: 11)
                .foregroundStyle(Color.trendUp)
                .accessibilityLabel("Price up")
        case .down:
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 11, height: 11)
                .foregroundStyle(Color.trendDown.opacity(0.8))
                .accessibilityLabel("Price down")
        case .unchanged:
            Image(systemName: "arrowtriangle.right.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 11, height: 11)
                .foregroundStyle(Color.trendFlat)
                .accessibilityLabel("Price unchanged")
        }
    }
}
