//
// This File belongs to SwiftRestEssentials
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct SettingsView: View {

    @AppStorage("selectedGymnasiumTrack") private var selectedTrackRaw: String = ""

    var body: some View {
        List {
            Section("Gymnasium") {
                ForEach(GymnasiumTrack.allCases, id: \.self) { track in
                    Button {
                        selectedTrackRaw = track.rawValue
                    } label: {
                        HStack {
                            Label(track.displayName, systemImage: track.systemImage)
                            Spacer()
                            if selectedTrackRaw == track.rawValue {
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
}
