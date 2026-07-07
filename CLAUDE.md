# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A collection of old ZAP (Zentrale Aufnahmeprüfung) exam papers for the Canton of Zurich's gymnasium entrance exams (2015–2025), plus the shell scripts used to download them.

Two exam tracks are covered:
- **Langgymnasium (LG)** — long-track gymnasium (6 years)
- **Kurzgymnasium (KG)** — short-track gymnasium (4 years), also covers HMS/IMS

Each track has exams in two subjects: **Deutsch** (Sprachprüfung + Aufsatz) and **Mathematik**.

## Data structure

```
data/
  gymi_langzeitgymnasium_downloads.sh   # download script for LG
  gymi_kurzgymnasium_downloads.sh       # download script for KG
  gymi_langgymnasium/                   # downloaded LG PDFs
    deutsch/      # Sprachprüfung, Textblatt, Aufsatzthemen, Lösungen
    mathematik/   # Aufgaben + Lösungen
    merkblatt/    # Prüfungsanforderungen
  gymi_kurzgymnasium/                   # downloaded KG PDFs (same structure)
```

## Refreshing / re-downloading the data

Scripts must be run from inside the `data/` directory so relative paths resolve correctly:

```bash
cd data
bash gymi_langzeitgymnasium_downloads.sh   # downloads into ./gymi_langgymnasium/
bash gymi_kurzgymnasium_downloads.sh       # downloads into ./gymi_kurzgymnasium/
```

The source is the official Canton of Zurich website (`www.zh.ch`). File URLs follow predictable patterns — if a new year's exams are available, add the filenames to the `declare -a` arrays in the relevant script.

## PDF naming convention

`{year}_{subject}_{type}[_{track}].pdf`

- `_aufgaben` = exam questions, `_loesung(en)` = answer key
- `_lg` = Langgymnasium, `_kg` = Kurzgymnasium, `_kg_hms` = KG + HMS track
- Some years omit the track suffix when the file applies to both tracks
- Two files in `gymi_langgymnasium/deutsch/` are missing the `.pdf` extension (known issue from the source): `2016_sprachpruefung_loesung_lgpdf` and `2018_sprachpruefung_lgpdf`
