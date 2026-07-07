//
// This File belongs to SwiftRestEssentials 
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct ContentView: View {

    let track: GymnasiumTrack

    var body: some View {
        List {
            NavigationLink {
                MathTaskListView(repository: MathTaskRepository(track: track))
            } label: {
                Label("Aufgaben", systemImage: "checklist")
            }

            NavigationLink {
                MathTestListView(track: track)
            } label: {
                Label("Prüfungen", systemImage: "doc.text")
            }

            NavigationLink {
                MathCategoryListView(track: track)
            } label: {
                Label("Kategorien", systemImage: "list.bullet")
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
        ContentView(track: .long)
    }
}
