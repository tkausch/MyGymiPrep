//
// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import PDFKit
import SwiftUI

struct EssayDetailView: View {

    let essay: Essay

    @AppStorage private var isDone: Bool
    @AppStorage private var isBookmarked: Bool

    init(essay: Essay) {
        self.essay = essay
        _isDone = AppStorage(wrappedValue: false, "essay.isDone.\(essay.id)")
        _isBookmarked = AppStorage(wrappedValue: false, "essay.isBookmarked.\(essay.id)")
    }

    var body: some View {
        List {
            Section {
                Text(essay.title)
                    .font(.headline)

                Text(essay.beschreibung)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                if let url = essay.aufsatzURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Aufsatzthemen-PDF")
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        printPDF(url: url)
                                    } label: {
                                        Image(systemName: "printer")
                                    }
                                }
                            }
                    } label: {
                        Label("Aufsatzthemen-PDF öffnen", systemImage: "doc.richtext")
                    }
                } else {
                    Label("Aufsatzthemen-PDF nicht gefunden", systemImage: "exclamationmark.triangle")
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
        .navigationTitle(essay.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func printPDF(url: URL) {
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.outputType = .general
        printInfo.jobName = url.deletingPathExtension().lastPathComponent
        let controller = UIPrintInteractionController.shared
        controller.printInfo = printInfo
        controller.printingItem = url
        controller.present(animated: true)
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
        EssayDetailView(essay: Essay(
            jahr: 2025,
            nummer: 1,
            track: .short,
            title: "Abkürzungen",
            beschreibung: "Beschreibe einleitend, was die beiden Bilder allgemein über «Abkürzungen» aussagen."
        ))
    }
}
