import SwiftUI

struct ReturnWordmark: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "arrow.uturn.backward.circle.fill")
                .font(.title2)
                .foregroundStyle(Color.returnOlive)
            Text("RETURN")
                .font(.system(.headline, design: .rounded, weight: .bold))
                .tracking(2.2)
                .foregroundStyle(Color.returnInk)
        }
    }
}

struct MetricPill: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.system(.title3, design: .rounded, weight: .semibold)).foregroundStyle(Color.returnInk)
            Text(label).font(.caption).foregroundStyle(Color.returnStone)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color.returnIvory.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct SectionHeader: View {
    let title: String
    let subtitle: String?
    init(_ title: String, subtitle: String? = nil) { self.title = title; self.subtitle = subtitle }
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title).font(.title3.weight(.semibold)).foregroundStyle(Color.returnInk)
            if let subtitle { Text(subtitle).font(.subheadline).foregroundStyle(Color.returnStone) }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
