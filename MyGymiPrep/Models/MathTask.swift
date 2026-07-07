//
// This File belongs to SwiftRestEssentials
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

enum GymnasiumTrack: String, CaseIterable, Sendable, Decodable {
    case long  = "Langgymnasium"
    case short  = "Kurzgymnasium"

    var displayName: String { rawValue }

    var subtitle: String {
        switch self {
        case .long: return "6 Jahre · ab 6. Klasse"
        case .short: return "4 Jahre · ab 8. Klasse (Sek)"
        }
    }

    var systemImage: String {
        switch self {
        case .long: return "graduationcap.fill"
        case .short: return "graduationcap"
        }
    }
    
    var abbrevation: String {
        switch self {
        case .long: return "lg"
        case .short: return "kg"
        }
    }
}

enum Difficulty: String, Decodable {
    case einfach
    case leicht
    case mittel
    case mittelSchwer = "mittel-schwer"
    case schwer

    var displayName: String {
        switch self {
        case .einfach: return "Einfach"
        case .leicht: return "Leicht"
        case .mittel: return "Mittel"
        case .mittelSchwer: return "Mittel-Schwer"
        case .schwer: return "Schwer"
        }
    }
}

enum MathCategory: String, CaseIterable, Sendable, Decodable {
    
    // Long Term gymi
    
    case fractions             = "Bruchrechnen"
    case reverseCalculation    = "Rueckwaertsrechnen"
    case proportionality       = "Proportionalitaet"
    case speedTimeDistance     = "Geschwindigkeit, Zeit und Strecke"
    case geometryAreaPerimeter = "Geometrie: Flaeche und Umfang"
    case geometryVolumeSurface = "Geometrie: Volumen und Oberflaeche"
    case geometrySymmetry      = "Geometrie: Symmetrie"
    case geometryConstruction  = "Geometrie: Konstruktion"
    case ratiosEquations       = "Verhaeltnisse und Gleichungen"
    case combinatorics         = "Kombinatorik und systematisches Probieren"
    case spatialReasoning      = "Raumvorstellung (3D-Geometrie)"
    case decimalsNumberLine    = "Dezimalzahlen und Zahlenstrahl"
    case basicOperations       = "Grundoperationen und geschicktes Rechnen"
    case sequencesPatterns     = "Zahlenfolgen und Muster"
    case multiStepWordProblems = "Sachrechnen mehrstufig"
    case optimization          = "Optimierung"
    case arithmeticLaws        = "Rechengesetze"
    case coordinateSystem      = "Koordinatensystem"

    // Short Term gymi (Kurzgymnasium)
    case percentages           = "Prozentrechnen"
    case equations             = "Gleichungen"
    case functions             = "Funktionen/Diagramme"
    case termTransformation    = "Termumformung"
    case areaCalculation       = "Flächenberechnung"
    case volumeCalculation     = "Volumenberechnung"
    case construction          = "Konstruktion"
    case probability           = "Wahrscheinlichkeit"
    case numberSequences       = "Zahlenfolgen"
    case wordProblems          = "Sachaufgabe/Modellierung"

    static func shortterm() -> [MathCategory] {
        [
            .fractions,
            .reverseCalculation,
            .proportionality,
            .speedTimeDistance,
            .percentages,
            .equations,
            .ratiosEquations,
            .functions,
            .termTransformation,
            .areaCalculation,
            .geometryAreaPerimeter,
            .volumeCalculation,
            .geometryVolumeSurface,
            .construction,
            .combinatorics,
            .probability,
            .spatialReasoning,
            .numberSequences,
            .wordProblems,
            .basicOperations,
            .decimalsNumberLine,
            .coordinateSystem
        ]
    }
    
    
    static func longterm() -> [MathCategory] {
        [
            .fractions,
            .reverseCalculation,
            .proportionality,
            .speedTimeDistance,
            .geometryAreaPerimeter,
            .geometryVolumeSurface,
            .geometrySymmetry,
            .geometryConstruction,
            .ratiosEquations,
            .combinatorics,
            .spatialReasoning,
            .decimalsNumberLine,
            .basicOperations,
            .sequencesPatterns,
            .multiStepWordProblems,
            .optimization,
            .arithmeticLaws,
            .coordinateSystem
        ]
    }
    
    
  
    
}

struct MathTask: Identifiable, Decodable {
    
    let year: Int
    let taskNumber: String
    let track: GymnasiumTrack
    let key: String
    let description: String
    let topic: String
    let category: MathCategory
    let difficulty: Difficulty
    let points: Int

    var id: String { key }
    
    var examURL: URL? {
        let name = "\(year)_mathematik_aufgaben_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }

    var solutionURL: URL? {
        let name = "\(year)_mathematik_loesungen_\(track.abbrevation)"
        return Bundle.main.url(forResource: name, withExtension: "pdf")
    }

}
