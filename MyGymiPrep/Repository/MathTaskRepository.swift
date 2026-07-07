//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import Foundation

// MARK: - Errors

enum MathTaskRepositoryError: LocalizedError {
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

protocol MathTaskRepositoryProtocol {
    func allTasks() throws -> [MathTask]
    func tasks(forCategory category: MathCategory) throws -> [MathTask]
    func tasks(forDifficulty difficulty: Difficulty) throws -> [MathTask]
    func tasks(forYear year: Int) throws -> [MathTask]
    func tasksByYear() throws -> [Int: [MathTask]]
    func taskCountsByCategory() throws -> [MathCategory: Int]
}

// MARK: - Repository

final class MathTaskRepository: MathTaskRepositoryProtocol {

    private let bundle: Bundle
    private let track: GymnasiumTrack
    private let resourceName = "mathtasks"
    private var cachedTasks: [MathTask]?

    init(bundle: Bundle = .main, track: GymnasiumTrack = .long) {
        self.bundle = bundle
        self.track = track
    }

    func allTasks() throws -> [MathTask] {
        if let cached = cachedTasks { return cached }
        let tasks = try loadJSON().filter { $0.track == track }
        cachedTasks = tasks
        return tasks
    }

    func tasks(forCategory category: MathCategory) throws -> [MathTask] {
        try allTasks().filter { $0.category == category }
    }

    func tasks(forDifficulty difficulty: Difficulty) throws -> [MathTask] {
        try allTasks().filter { $0.difficulty == difficulty }
    }

    func tasks(forYear year: Int) throws -> [MathTask] {
        try allTasks().filter { $0.year == year }
    }

    func tasksByYear() throws -> [Int: [MathTask]] {
        Dictionary(grouping: try allTasks(), by: \.year)
    }

    func taskCountsByCategory() throws -> [MathCategory: Int] {
        let tasks = try allTasks()
        return Dictionary(grouping: tasks, by: \.category).mapValues(\.count)
    }

    private func loadJSON() throws -> [MathTask] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw MathTaskRepositoryError.fileNotFound(resourceName)
        }
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode([MathTask].self, from: data)
        } catch let error as DecodingError {
            print(error.localizedDescription)
            throw MathTaskRepositoryError.parseError(error.localizedDescription)
        }
    }
}
