//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import SwiftUI

struct MathTaskListView: View {

    private enum Source {
        case all
        case category(MathCategory)
        case year(Int)

        var navigationTitle: String {
            switch self {
            case .all:
                return "Aufgaben"
            case .category(let category):
                return category.rawValue
            case .year(let year):
                return "Jahr \(String(year))"
            }
        }
    }

    private enum TaskFilter: String, CaseIterable, Identifiable {
        case all = "Alle"
        case open = "Offen"
        case done = "Erledigt"
        case bookmarked = "Markiert"

        var id: String { rawValue }
    }

    @Environment(AppSettings.self) private var appSettings
    @Environment(\.theme) private var theme

    private let source: Source
    private let repository: MathTaskRepository

    @State private var tasks: [MathTask] = []
    @State private var selectedFilter: TaskFilter = .all
    @State private var filterRefreshToken = 0
    @State private var loadError: String?

    private var filteredTasks: [MathTask] {
        _ = filterRefreshToken

        switch selectedFilter {
        case .all:
            return tasks
        case .open:
            return tasks.filter { task in
                !UserDefaults.standard.bool(forKey: "mathTask.isDone.\(task.id)")
            }
        case .done:
            return tasks.filter { task in
                UserDefaults.standard.bool(forKey: "mathTask.isDone.\(task.id)")
            }
        case .bookmarked:
            return tasks.filter { task in
                UserDefaults.standard.bool(forKey: "mathTask.isBookmarked.\(task.id)")
            }
        }
    }

    private var filteredTasksByYear: [Int: [MathTask]] {
        Dictionary(grouping: filteredTasks, by: \.year)
    }

    private var sortedYears: [Int] {
        filteredTasksByYear.keys.sorted(by: <)
    }

    init(repository: MathTaskRepository) {
        self.source = .all
        self.repository = repository
    }

    init(category: MathCategory, repository: MathTaskRepository) {
        self.source = .category(category)
        self.repository = repository
    }

    init(year: Int, repository: MathTaskRepository) {
        self.source = .year(year)
        self.repository = repository
    }

    var body: some View {
        List {
            Section {
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(TaskFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
            }

            ForEach(sortedYears, id: \.self) { year in
                Section(String(year)) {
                    ForEach(filteredTasksByYear[year, default: []].sorted {
                        $0.taskNumber.localizedStandardCompare($1.taskNumber) == .orderedAscending
                    }) { task in
                        NavigationLink {
                            MathTaskDetailView(task: task)
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(task.description)
                                    .font(.headline)

                                Text(task.topic)
                                    .foregroundStyle(.secondary)

                                HStack {
                                    DifficultyStarsView(difficulty: task.difficulty)
                                    Spacer()
                                    MathTaskBookmarkIndicator(task: task)
                                    MathTaskDoneIndicator(task: task)
                                    Text("\(task.points) Punkte")
                                        .foregroundStyle(.secondary)
                                        .monospacedDigit()
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .navigationTitle(source.navigationTitle)
        .task(id: appSettings.selectedTrack) {
            do {
                tasks = try loadTasks()
            } catch {
                loadError = error.localizedDescription
            }
        }
        .onAppear {
            filterRefreshToken += 1
        }
        .alert("Fehler", isPresented: Binding(
            get: { loadError != nil },
            set: { if !$0 { loadError = nil } }
        )) {
            Button("OK", role: .cancel) { loadError = nil }
        } message: {
            Text(loadError ?? "")
        }
    }

    private func loadTasks() throws -> [MathTask] {
        switch source {
        case .all:
            return try repository.allTasks()
        case .category(let category):
            return try repository.tasks(forCategory: category)
        case .year(let year):
            return try repository.tasks(forYear: year).sorted { lhs, rhs in
                lhs.taskNumber.localizedStandardCompare(rhs.taskNumber) == .orderedAscending
            }
        }
    }
}

private struct DifficultyStarsView: View {

    let difficulty: Difficulty

    @Environment(\.theme) private var theme

    private var filledStarCount: Int {
        switch difficulty {
        case .einfach: return 0
        case .leicht: return 1
        case .mittel: return 2
        case .mittelSchwer: return 3
        case .schwer: return 4
        }
    }

    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...4, id: \.self) { index in
                Image(systemName: index <= filledStarCount ? "star.fill" : "star")
                    .foregroundStyle(index <= filledStarCount ? theme.starFilled : .secondary)
            }
        }
        .accessibilityLabel("Schwierigkeit: \(difficulty.displayName)")
    }
}

private struct MathTaskBookmarkIndicator: View {

    let task: MathTask

    @AppStorage private var isBookmarked: Bool
    @Environment(\.theme) private var theme

    init(task: MathTask) {
        self.task = task
        _isBookmarked = AppStorage(wrappedValue: false, "mathTask.isBookmarked.\(task.id)")
    }

    var body: some View {
        if isBookmarked {
            Image(systemName: "bookmark.fill")
                .foregroundStyle(theme.bookmarked)
                .accessibilityLabel("Mit Lesezeichen")
        }
    }
}

private struct MathTaskDoneIndicator: View {

    let task: MathTask

    @AppStorage private var isDone: Bool
    @Environment(\.theme) private var theme

    init(task: MathTask) {
        self.task = task
        _isDone = AppStorage(wrappedValue: false, "mathTask.isDone.\(task.id)")
    }

    var body: some View {
        Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
            .foregroundStyle(isDone ? theme.done : .secondary)
            .accessibilityLabel(isDone ? "Erledigt" : "Nicht erledigt")
    }
}

#Preview {
    NavigationStack {
        MathTaskListView(category: .fractions, repository: MathTaskRepository())
    }
}
