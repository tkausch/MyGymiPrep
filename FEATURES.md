# Feature-Konzept: Gymi-Prep App
### Intelligente Vorbereitung auf die ZAP (Langgymnasium, Kanton Zürich)

---

## 1. Vision

Alte ZAP-Prüfungen sind frei verfügbar, aber ungenutztes Rohmaterial: PDFs zum Ausdrucken, ohne Struktur, ohne Feedback, ohne Anpassung an den einzelnen Schüler. Die App verwandelt dieses Rohmaterial in ein strukturiertes, adaptives Lernsystem für 6.-Klässler (und deren Eltern), das gezielt auf Schwächen eingeht statt stur ganze Prüfungen abzuarbeiten.

**Zielgruppe:** Primär Schüler der 6. Klasse (10–12 Jahre) im Kanton Zürich, sekundär deren Eltern als Lernbegleiter.

---

## 2. Core-Konzept: Aufgaben-Atomisierung

Der zentrale Hebel gegenüber reinen PDF-Sammlungen: jede Prüfung wird in einzelne Aufgaben zerlegt und mit Metadaten angereichert.

### Datenmodell pro Aufgabe

| Feld | Beispiel |
|---|---|
| Fach | Mathematik / Deutsch |
| Jahr | 2015–2025 |
| Thema | Bruchrechnen, Textaufgaben, Geometrie, Sachrechnen, Prozentrechnung (Mathe) / Rechtschreibung, Grammatik, Textverständnis, Wortschatz (Deutsch) |
| Unterthema | z.B. bei Geometrie: Flächenberechnung, Winkel, Spiegelung |
| Schwierigkeitsgrad | 1–3 (aus Musterlösung/Expertenbewertung abgeleitet) |
| Aufgabentyp | Multiple Choice, offene Rechnung, Lückentext, Aufsatz |
| Quelle | Original-PDF + Seitenzahl (Nachvollziehbarkeit) |
| Lösung | Kurzlösung (aus offiziellem PDF) |
| Lösungsweg | Ausformulierte Schritt-für-Schritt-Erklärung (redaktionell ergänzt) |

**Aufwand-Hinweis:** Das Taggen von ~55–60 PDFs (Lang- und Kurzgymnasium zusammen, je ~11 Jahrgänge) in einzelne Aufgaben ist der grösste manuelle Content-Aufwand des Projekts. Realistisch: OCR/Extraktion halbautomatisch, Themen-Tagging manuell oder KI-gestützt mit manueller Prüfung.

---

## 3. Feature-Übersicht (priorisiert)

### Must-Have (MVP)

1. **Themen-Browser**
   Schüler wählt Fach + Thema, App stellt alle passenden Aufgaben aus allen Jahrgängen zusammen. Löst dein Ausgangsbeispiel direkt.

2. **Prüfungsmodus**
   Eine komplette historische Prüfung am Stück, mit Original-Zeitlimit (Mathematik 60 Min., Deutsch-Sprachprüfung 45 Min. etc.), realistische Simulation.

3. **Sofort-Feedback mit Lösungsweg**
   Nach jeder Aufgabe: richtig/falsch + ausformulierter Lösungsweg, nicht nur Endresultat.

4. **Fortschritts-Tracking**
   Pro Thema: Anzahl bearbeitet, Trefferquote, Zeitaufwand. Einfaches Balkendiagramm reicht fürs MVP.

5. **Offline-Fähigkeit**
   Wie bei SwissFlora: alle Aufgaben lokal gespeichert, kein Internet nötig während des Übens.

### Should-Have (V2)

6. **Adaptives Üben**
   Statt manueller Themenwahl: App schlägt basierend auf Fehlerprofil automatisch die nächsten 10 Aufgaben vor (leichte Spaced-Repetition-Logik, kein komplexes ML nötig für den Start).

7. **Schwächen-Radar**
   Visuelles Spinnendiagramm über alle Themen: sofort erkennbar, wo Nachholbedarf besteht.

8. **Eltern-Dashboard**
   Separater (optionaler) Zugang für Eltern: Fortschritt, verbrachte Zeit, keine Detaildaten zu einzelnen falschen Antworten (Persönlichkeitsschutz des Kindes, auch bei minderjährigen Nutzern sensibel zu behandeln).

9. **Trend-Analyse über Jahrgänge**
   "Textaufgaben zu Geschwindigkeit kamen in 4 der letzten 5 Prüfungen vor" – hilft bei der Priorisierung der letzten Wochen vor der Prüfung.

### Nice-to-Have (V3+)

10. **Handschrift-Eingabe für Mathematik** (Apple Pencil, iPad)
    Löse-Weg handschriftlich erfassen, grobe Plausibilitätsprüfung statt reiner Text-Eingabe.

11. **KI-Feedback für Aufsätze**
    Vorsichtig einzusetzen: strukturelles Feedback (Aufbau, roter Faden, Wortschatzvielfalt) statt automatischer Bewertung – echtes Schreibenlernen darf nicht durch KI-Abkürzung ersetzt werden.

12. **Mehrsprachigkeit**
    Falls Expansion auf andere Kantone (z.B. Aargau-Prüfungsarchiv existiert bereits) sinnvoll wird.

---

## 4. Technische Architektur (Vorschlag)

Passend zu deinem bestehenden Stack (SwissFlora als Referenz):

- **Plattform:** iOS-first (SwiftUI), analog zu SwissFlora-Architektur
- **Content-Storage:** Lokale SQLite-DB (via SQLDelight oder Core Data) mit allen Aufgaben-Metadaten + Lösungen, gebündelt in der App oder per Erstlauf-Download
- **Aufgaben-Rendering:** PDF-Ausschnitte pro Aufgabe (Bild) + strukturierte Zusatzdaten, kein Full-PDF-Viewer nötig
- **Tracking:** Lokale Fortschrittsdaten, optional iCloud-Sync für Eltern-Dashboard auf zweitem Gerät
- **Content-Pipeline:** Separates internes Tool zum Taggen/Zerlegen der PDFs (einmaliger Aufwand pro Jahrgang, danach nur Pflege bei neuen Prüfungen)

---

## 5. Rechtlicher Hinweis

Die ZAP-Prüfungen des Kantons Zürich sind auf der offiziellen Seite frei zum Download bereitgestellt, aber die Rechte liegen beim Kanton bzw. dem Mittelschul- und Berufsbildungsamt. Vor kommerzieller Nutzung (App-Verkauf) sollte geklärt werden, ob eine Weiterverarbeitung/Wiederveröffentlichung der Originalinhalte (auch in aufbereiteter Form) erlaubt ist – ähnlich wie du das bei SwissFlora mit der InfoFlora-CC-BY-4.0-Lizenz sauber gelöst hast. Eine Anfrage beim Mittelschul- und Berufsbildungsamt wäre ein sinnvoller erster Schritt.

---

## 6. Monetarisierungs-Optionen

- **Einmalkauf** (wie SwissFlora, CHF 4.90–9.90): passt zum Nutzungsmuster – Eltern kaufen einmal für die Vorbereitungsphase (mehrere Monate), kein Abo-Ermüdungseffekt
- **Freemium:** Grundfunktionen (ein Fach, wenige Jahrgänge) gratis, Vollversion (alle Fächer/Jahrgänge, adaptives Üben) kostenpflichtig
- **Family-Sharing:** Für Eltern mit mehreren Kindern in unterschiedlichen Jahren relevant

---

## 7. Nächste Schritte (Vorschlag)

1. Klärung Nutzungsrechte mit Mittelschul- und Berufsbildungsamt
2. Pilot: Ein Jahrgang (z.B. 2025) vollständig taggen und in Themen-Browser + Prüfungsmodus umsetzen → Machbarkeits- und Aufwandstest für Content-Pipeline
3. Basierend auf Pilot-Aufwand: Entscheidung, ob Taggen manuell, KI-gestützt oder hybrid erfolgt
4. MVP-Scope final festlegen (Punkte 1–5 oben)
