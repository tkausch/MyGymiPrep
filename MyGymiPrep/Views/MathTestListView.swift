//
// This File belongs to SwiftRestEssentials
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct MathTestListView: View {

    @State private var tasksByYear: [Int: [MathTask]] = [:]
    @State private var loadError: String?

    private let repository: MathTaskRepository

    init(track: GymnasiumTrack) {
        self.repository = MathTaskRepository(track: track)
    }

    private var years: [Int] {
        tasksByYear.keys.sorted(by: >)
    }

    var body: some View {
        List(years, id: \.self) { year in
            let tasks = tasksByYear[year, default: []]
            NavigationLink {
                MathTaskListView(year: year, repository: repository)
            } label: {
                HStack {
                    Text("Jahr \(String(year))")
                    Spacer()
                    Text("\(tasks.count)")
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .navigationTitle("Prüfungen")
        .task {
            do {
                tasksByYear = try repository.tasksByYear()
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
        MathTestListView(track: .long)
    }
}
