// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct SprachpruefungListView: View {

    private enum TaskFilter: String, CaseIterable, Identifiable {
        case alle = "Alle"
        case offen = "Offen"
        case erledigt = "Erledigt"
        case markiert = "Markiert"

        var id: String { rawValue }
    }

    @Environment(AppSettings.self) private var appSettings

    @State private var allItems: [LanguageTask] = []
    @State private var selectedFilter: TaskFilter = .alle
    @State private var filterRefreshToken = 0
    @State private var loadError: String?

    let thema: String?

    init(thema: String? = nil) {
        self.thema = thema
    }

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    private var filteredItemsByYear: [Int: [LanguageTask]] {
        _ = filterRefreshToken
        var filtered = thema != nil ? allItems.filter { $0.thema == thema } : allItems
        switch selectedFilter {
        case .alle:
            break
        case .offen:
            filtered = filtered.filter {
                !UserDefaults.standard.bool(forKey: "sprachpruefung.isDone.\($0.id)")
            }
        case .erledigt:
            filtered = filtered.filter {
                UserDefaults.standard.bool(forKey: "sprachpruefung.isDone.\($0.id)")
            }
        case .markiert:
            filtered = filtered.filter {
                UserDefaults.standard.bool(forKey: "sprachpruefung.isBookmarked.\($0.id)")
            }
        }
        return Dictionary(grouping: filtered, by: \.jahr)
    }

    private var sortedYears: [Int] {
        filteredItemsByYear.keys.sorted(by: <)
    }

    var body: some View {
        List {
            Section {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
            }

            ForEach(sortedYears, id: \.self) { year in
                Section(String(year)) {
                    ForEach(filteredItemsByYear[year, default: []].sorted { $0.nummer < $1.nummer }) { item in
                        NavigationLink {
                            SprachpruefungDetailView(item: item)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(item.title)
                                    .font(.headline)

                                Text(item.beschreibung)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(2)

                                HStack {
                                    Spacer()
                                    LanguageTaskBookmarkIndicator(item: item)
                                    LanguageTaskDoneIndicator(item: item)
                                    if let punkte = item.punktzahl {
                                        Text("\(punkte) P.")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .monospacedDigit()
                                    }
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle(thema ?? "Aufgaben")
        .task(id: track) {
            do {
                allItems = try LanguageTaskRepository().items(byGymnasiumTrack: track)
            } catch {
                loadError = error.localizedDescription
            }
        }
        .onAppear {
            filterRefreshToken += 1
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

private struct LanguageTaskBookmarkIndicator: View {

    let item: LanguageTask

    @AppStorage private var isBookmarked: Bool

    init(item: LanguageTask) {
        self.item = item
        _isBookmarked = AppStorage(wrappedValue: false, "sprachpruefung.isBookmarked.\(item.id)")
    }

    var body: some View {
        if isBookmarked {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(.blue)
                .accessibilityLabel("Mit Lesezeichen")
        }
    }
}

private struct LanguageTaskDoneIndicator: View {

    let item: LanguageTask

    @AppStorage private var isDone: Bool

    init(item: LanguageTask) {
        self.item = item
        _isDone = AppStorage(wrappedValue: false, "sprachpruefung.isDone.\(item.id)")
    }

    var body: some View {
        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isDone ? .green : .secondary)
            .accessibilityLabel(isDone ? "Erledigt" : "Nicht erledigt")
    }
}

#Preview {
    NavigationStack {
        SprachpruefungListView()
    }
    .environment(AppSettings())
}
