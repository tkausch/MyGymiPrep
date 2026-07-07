//
// This File belongs to SwiftRestEssentials 
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.


import SwiftUI

@main
struct MyGymiPrepApp: App {

    @AppStorage("selectedGymnasiumTrack") private var selectedTrackRaw: String = ""

    private var selectedTrack: GymnasiumTrack? {
        GymnasiumTrack(rawValue: selectedTrackRaw)
    }

    var body: some Scene {
        WindowGroup {
            if let track = selectedTrack {
                NavigationStack {
                    ContentView(track: track)
                }
            } else {
                GymnasiumTrackSelectionView { track in
                    selectedTrackRaw = track.rawValue
                }
            }
        }
    }
}
