// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct SprachpruefungKategorienListView: View {

    @Environment(AppSettings.self) private var appSettings

    @State private var stats: [ThemaStat] = []
    @State private var loadError: String?

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    var body: some View {
        List(stats) { stat in
            NavigationLink {
                SprachpruefungListView(thema: stat.thema)
            } label: {
                HStack {
                    Text(stat.thema)
                    Spacer()
                    Text("\(stat.count)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
        }
        .navigationTitle("Kategorien")
        .task(id: track) {
            do {
                stats = try LanguageTaskRepository().themaStats(track: track)
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
        SprachpruefungKategorienListView()
    }
    .environment(AppSettings())
}
