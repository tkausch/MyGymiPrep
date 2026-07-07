//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct SettingsView: View {

    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        List {
            Section("Gymnasium") {
                ForEach(GymnasiumTrack.allCases, id: \.self) { track in
                    Button {
                        appSettings.selectedTrack = track
                    } label: {
                        HStack {
                            Label(track.displayName, systemImage: track.systemImage)
                            Spacer()
                            if appSettings.selectedTrack == track {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.blue)
                            }
                        }
                    }
                    .foregroundStyle(.primary)
                }
            }
        }
        .navigationTitle("Einstellungen")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(AppSettings())
}
