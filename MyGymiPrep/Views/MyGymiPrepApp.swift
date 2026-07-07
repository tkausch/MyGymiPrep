//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.


import SwiftUI

@main
struct MyGymiPrepApp: App {

    @State private var appSettings = AppSettings()

    var body: some Scene {
        WindowGroup {
            Group {
                if appSettings.selectedTrack != nil {
                    NavigationStack {
                        ContentView()
                    }
                } else {
                    GymnasiumTrackSelectionView { track in
                        appSettings.selectedTrack = track
                    }
                }
            }
            .environment(appSettings)
        }
    }
}
