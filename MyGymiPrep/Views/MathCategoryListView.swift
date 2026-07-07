//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct MathCategoryListView: View {

    @Environment(AppSettings.self) private var appSettings

    @State private var categoryCounts: [MathCategory: Int] = [:]
    @State private var loadError: String?

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    private var categoriesByTaskCount: [MathCategory] {
        categoryCounts.keys.sorted { lhs, rhs in
            let lhsCount = categoryCounts[lhs, default: 0]
            let rhsCount = categoryCounts[rhs, default: 0]
            if lhsCount == rhsCount {
                return lhs.rawValue < rhs.rawValue
            }
            return lhsCount > rhsCount
        }
    }

    var body: some View {
        let repo = MathTaskRepository(track: track)
        List(categoriesByTaskCount, id: \.self) { category in
            let count = categoryCounts[category, default: 0]
            NavigationLink {
                MathTaskListView(category: category, repository: repo)
            } label: {
                HStack {
                    Text(category.rawValue)
                    Spacer()
                    Text("\(count)")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .navigationTitle("Kategorien")
        .task(id: track) {
            do {
                categoryCounts = try repo.taskCountsByCategory()
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

#Preview {
    NavigationStack {
        MathCategoryListView()
    }
    .environment(AppSettings())
}
