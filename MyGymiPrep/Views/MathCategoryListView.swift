//
// This File belongs to SwiftRestEssentials
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct MathCategoryListView: View {

    @State private var categoryCounts: [MathCategory: Int] = [:]
    @State private var loadError: String?

    private let repository: MathTaskRepository

    init(track: GymnasiumTrack) {
        self.repository = MathTaskRepository(track: track)
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
        List(categoriesByTaskCount, id: \.self) { category in
            let count = categoryCounts[category, default: 0]
            NavigationLink {
                MathTaskListView(category: category, repository: repository)
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
        .task {
            do {
                categoryCounts = try repository.taskCountsByCategory()
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
        MathCategoryListView(track: .long)
    }
}
