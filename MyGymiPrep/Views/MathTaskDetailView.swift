//
// This File belongs to SwiftRestEssentials
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import PDFKit
import SwiftUI

struct MathTaskDetailView: View {

    let task: MathTask

    @AppStorage private var isDone: Bool
    @AppStorage private var isBookmarked: Bool


    init(task: MathTask) {
        self.task = task
        _isDone = AppStorage(wrappedValue: false, "mathTask.isDone.\(task.id)")
        _isBookmarked = AppStorage(wrappedValue: false, "mathTask.isBookmarked.\(task.id)")
    }

    var body: some View {
        List {
            Section {
                Text(task.description)
                    .font(.headline)

                Text(task.topic)
                    .foregroundStyle(.secondary)
            }

            Section {
                LabeledContent("Schwierigkeit", value: task.difficulty.displayName)
                LabeledContent("Punkte", value: "\(task.points)")
            }

            Section {
                if let url = task.examURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Pruefungs-PDF")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Pruefungs-PDF oeffnen", systemImage: "doc.richtext")
                    }
                } else {
                    Label("Pruefungs-PDF nicht gefunden", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }

                if let url = task.solutionURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Loesungs-PDF")
                            .navigationBarTitleDisplayMode(.inline)
                    } label: {
                        Label("Loesungs-PDF oeffnen", systemImage: "checkmark.rectangle")
                    }
                } else {
                    Label("Loesungs-PDF nicht gefunden", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }
            }

            Section {
                Button {
                    isBookmarked.toggle()
                } label: {
                    Label(
                        isBookmarked ? "Lesezeichen entfernen" : "Lesezeichen setzen",
                        systemImage: isBookmarked ? "bookmark.fill" : "bookmark"
                    )
                }
                .foregroundStyle(isBookmarked ? .blue : .secondary)

                Button {
                    isDone.toggle()
                } label: {
                    Label(
                        isDone ? "Erledigt" : "Nicht erledigt",
                        systemImage: isDone ? "checkmark.circle.fill" : "circle"
                    )
                }
                .foregroundStyle(isDone ? .green : .secondary)
            }
        }
        .navigationTitle("Aufgabe \(task.taskNumber)")
    }

}

private struct PDFDocumentView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        pdfView.document = PDFDocument(url: url)
        return pdfView
    }

    func updateUIView(_ pdfView: PDFView, context: Context) {
        guard pdfView.document?.documentURL != url else { return }
        pdfView.document = PDFDocument(url: url)
    }
}

#Preview {
    NavigationStack {
        MathTaskDetailView(task: MathTask(
            year: 2025,
            taskNumber: "1",
            track: .long,
            key: "Mathe_2025_1",
            description: "Berechne den Wert des Terms.",
            topic: "Terme",
            category: .fractions,
            difficulty: .mittel,
            points: 3
        ))
    }
}
