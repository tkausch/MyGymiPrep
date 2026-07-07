//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

struct Essay: Identifiable, Decodable {
    let jahr: Int
    let nummer: Int
    let track: GymnasiumTrack
    let title: String
    let beschreibung: String

    var id: String { "\(jahr)_essay_\(nummer)_\(track.rawValue)" }

    var aufsatzURL: URL? {
        let name = "\(jahr)_aufsatzthemen_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }
}
