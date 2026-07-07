//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct MathTestListView: View {

    @Environment(AppSettings.self) private var appSettings

    @State private var tasksByYear: [Int: [MathTask]] = [:]
    @State private var loadError: String?

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    private var years: [Int] {
        tasksByYear.keys.sorted(by: >)
    }

    var body: some View {
        let repo = MathTaskRepository(track: track)
        List(years, id: \.self) { year in
            let tasks = tasksByYear[year, default: []]
            NavigationLink {
                MathTaskListView(year: year, repository: repo)
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
        .task(id: track) {
            do {
                tasksByYear = try repo.tasksByYear()
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
        MathTestListView()
    }
    .environment(AppSettings())
}
