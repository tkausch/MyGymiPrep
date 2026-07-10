//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct ContentView: View {

    @Environment(AppSettings.self) private var appSettings

    private var track: GymnasiumTrack {
        appSettings.selectedTrack ?? .long
    }

    var body: some View {
        List {
            Section("DEUTSCH") {
                NavigationLink {
                    SprachpruefungListView()
                } label: {
                    Label("Aufgaben", systemImage: "text.magnifyingglass")
                }

                NavigationLink {
                    EssayListView()
                } label: {
                    Label("Aufsatz", systemImage: "text.alignleft")
                }

                NavigationLink {
                    SprachpruefungKategorienListView()
                } label: {
                    Label("Kategorien", systemImage: "list.bullet")
                }
            }

            Section("MATHEMATIK") {
                NavigationLink {
                    MathTaskListView(repository: MathTaskRepository(track: track))
                } label: {
                    Label("Aufgaben", systemImage: "checklist")
                }

                NavigationLink {
                    MathTestListView()
                } label: {
                    Label("Prüfungen", systemImage: "doc.text")
                }

                NavigationLink {
                    MathCategoryListView()
                } label: {
                    Label("Kategorien", systemImage: "list.bullet")
                }
            }
        }
        .navigationTitle(track.displayName)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    SettingsView()
                } label: {
                    Label("Einstellungen", systemImage: "gearshape")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
    .environment(AppSettings())
}
