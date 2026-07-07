//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

// MARK: - Errors

enum EssayRepositoryError: LocalizedError {
    case fileNotFound(String)
    case parseError(String)

    var errorDescription: String? {
        switch self {
        case .fileNotFound(let name):
            return "Die JSON-Datei '\(name).json' wurde im Bundle nicht gefunden."
        case .parseError(let message):
            return "JSON-Parsefehler: \(message)"
        }
    }
}

// MARK: - Protocol

protocol EssayRepositoryProtocol {
    func allEssays() throws -> [Essay]
    func essays(forYear year: Int) throws -> [Essay]
    func essaysByYear() throws -> [Int: [Essay]]
    func essays(byGymnasiumTrack track: GymnasiumTrack) throws -> [Essay]
}

// MARK: - Repository

final class EssayRepository: EssayRepositoryProtocol {

    private let bundle: Bundle
    private let resourceName = "aufsatz"
    private var cachedEssays: [Essay]?

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func allEssays() throws -> [Essay] {
        if let cached = cachedEssays { return cached }
        let essays = try loadJSON()
        cachedEssays = essays
        return essays
    }

    func essays(forYear year: Int) throws -> [Essay] {
        try allEssays().filter { $0.jahr == year }
    }

    func essaysByYear() throws -> [Int: [Essay]] {
        Dictionary(grouping: try allEssays(), by: \.jahr)
    }

    func essays(byGymnasiumTrack track: GymnasiumTrack) throws -> [Essay] {
        try allEssays().filter { $0.track == track }
    }

    private func loadJSON() throws -> [Essay] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw EssayRepositoryError.fileNotFound(resourceName)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([Essay].self, from: data)
        } catch let error as DecodingError {
            throw EssayRepositoryError.parseError(error.localizedDescription)
        }
    }
}
