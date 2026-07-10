// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

// MARK: - Errors

enum LanguageTaskRepositoryError: LocalizedError {
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

// MARK: - ThemaStat

struct ThemaStat: Identifiable {
    let thema: String
    let count: Int
    let totalPunkte: Int

    var id: String { thema }
}

// MARK: - Repository

final class LanguageTaskRepository {

    private let bundle: Bundle
    private let resourceName = "sprachpruefung"
    private var cachedItems: [LanguageTask]?

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    func allItems() throws -> [LanguageTask] {
        if let cached = cachedItems { return cached }
        let items = try loadJSON()
        cachedItems = items
        return items
    }

    func items(byGymnasiumTrack track: GymnasiumTrack) throws -> [LanguageTask] {
        try allItems().filter { $0.track == track }
    }

    func themaStats(track: GymnasiumTrack) throws -> [ThemaStat] {
        let items = try self.items(byGymnasiumTrack: track)
        let grouped = Dictionary(grouping: items, by: \.thema)
        return grouped.map { thema, tasks in
            ThemaStat(
                thema: thema,
                count: tasks.count,
                totalPunkte: tasks.compactMap(\.punktzahl).reduce(0, +)
            )
        }.sorted { $0.count > $1.count }
    }

    private func loadJSON() throws -> [LanguageTask] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw LanguageTaskRepositoryError.fileNotFound(resourceName)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([LanguageTask].self, from: data)
        } catch let error as DecodingError {
            throw LanguageTaskRepositoryError.parseError(error.localizedDescription)
        }
    }
}
