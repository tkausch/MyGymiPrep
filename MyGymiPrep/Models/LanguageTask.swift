// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

struct LanguageTask: Identifiable, Decodable {
    let jahr: Int
    let nummer: Int
    let punktzahl: Int?
    let track: GymnasiumTrack
    let thema: String
    let beschreibung: String

    var id: String { "\(jahr)_sprachpruefung_\(nummer)_\(track.rawValue)" }

    var title: String { "Aufgabe \(nummer): \(thema)" }

    var pruefungURL: URL? {
        let name = "\(jahr)_sprachpruefung_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }

    var textURL: URL? {
        let name = "\(jahr)_textblatt_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }

    var loesungURL: URL? {
        let name = "\(jahr)_sprachpruefung_loesung_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }
}
