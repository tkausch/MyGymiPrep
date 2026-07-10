// This File belongs to MyGymiPrep
// Copyright © 2026 Thomas Kausch.
// All Rights Reserved.

import PDFKit
import SwiftUI

struct SprachpruefungDetailView: View {

    let item: LanguageTask

    @AppStorage private var isDone: Bool
    @AppStorage private var isBookmarked: Bool

    init(item: LanguageTask) {
        self.item = item
        _isDone = AppStorage(wrappedValue: false, "sprachpruefung.isDone.\(item.id)")
        _isBookmarked = AppStorage(wrappedValue: false, "sprachpruefung.isBookmarked.\(item.id)")
    }

    var body: some View {
        List {
            Section {
                Text(item.title)
                    .font(.headline)

                if let punkte = item.punktzahl {
                    Label("\(punkte) Punkte", systemImage: "checkmark.seal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                Text(item.beschreibung)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section {
                if let url = item.pruefungURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Prüfung \(item.jahr)")
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
                        Label("Prüfung öffnen", systemImage: "doc.text")
                    }
                } else {
                    Label("Prüfung nicht gefunden", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }

                if let url = item.textURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Textblatt")
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
                        Label("Textblatt öffnen", systemImage: "doc.richtext")
                    }
                } else {
                    Label("Textblatt nicht gefunden", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.secondary)
                }

                if let url = item.loesungURL {
                    NavigationLink {
                        PDFDocumentView(url: url)
                            .navigationTitle("Lösungen")
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
                        Label("Lösungen öffnen", systemImage: "doc.text.magnifyingglass")
                    }
                } else {
                    Label("Lösungen nicht gefunden", systemImage: "exclamationmark.triangle")
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
        .navigationTitle(item.title)
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
