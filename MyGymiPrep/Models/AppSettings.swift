//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation
import Observation

@Observable
final class AppSettings {

    private static let trackKey = "selectedGymnasiumTrack"

    var selectedTrack: GymnasiumTrack? {
        didSet {
            if let track = selectedTrack {
                UserDefaults.standard.set(track.rawValue, forKey: Self.trackKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Self.trackKey)
            }
        }
    }

    init() {
        let rawValue = UserDefaults.standard.string(forKey: Self.trackKey) ?? ""
        selectedTrack = GymnasiumTrack(rawValue: rawValue)
    }
}
