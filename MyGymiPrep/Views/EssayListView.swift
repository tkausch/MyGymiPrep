//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct EssayListView: View {

    @Environment(AppSettings.self) private var appSettings
    @Environment(\.theme) private var theme

    @State private var essaysByYear: [Int: [Essay]] = [:]
    @State private var loadError: String?

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    private var sortedYears: [Int] {
        essaysByYear.keys.sorted(by: <)
    }

    var body: some View {
        List {
            ForEach(sortedYears, id: \.self) { year in
                Section(String(year)) {
                    ForEach(essaysByYear[year, default: []].sorted { $0.nummer < $1.nummer }) { essay in
                        NavigationLink {
                            EssayDetailView(essay: essay)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(essay.title)
                                    .font(.headline)

                                Text(essay.beschreibung)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)

                                HStack {
                                    Spacer()
                                    EssayBookmarkIndicator(essay: essay)
                                    EssayDoneIndicator(essay: essay)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Aufsatz")
        .task(id: track) {
            do {
                let essays = try EssayRepository().essays(byGymnasiumTrack: track)
                essaysByYear = Dictionary(grouping: essays, by: \.jahr)
            } catch {
                loadError = error.localizedDescription
            }
        }
        .alert("Fehler", isPresented: Binding(
            get: { loadError != nil },
            set: { if !$0 { loadError = nil } }
        )) {
            Button("OK", role: .cancel) { loadError = nil }
        } message: {
            Text(loadError ?? "")
        }
    }
}

private struct EssayBookmarkIndicator: View {

    let essay: Essay

    @AppStorage private var isBookmarked: Bool
    @Environment(\.theme) private var theme

    init(essay: Essay) {
        self.essay = essay
        _isBookmarked = AppStorage(wrappedValue: false, "essay.isBookmarked.\(essay.id)")
    }

    var body: some View {
        if isBookmarked {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(theme.bookmarked)
                .accessibilityLabel("Mit Lesezeichen")
        }
    }
}

private struct EssayDoneIndicator: View {

    let essay: Essay

    @AppStorage private var isDone: Bool
    @Environment(\.theme) private var theme

    init(essay: Essay) {
        self.essay = essay
        _isDone = AppStorage(wrappedValue: false, "essay.isDone.\(essay.id)")
    }

    var body: some View {
        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isDone ? theme.done : .secondary)
            .accessibilityLabel(isDone ? "Erledigt" : "Nicht erledigt")
    }
}

#Preview {
    NavigationStack {
        EssayListView()
    }
    .environment(AppSettings())
}
