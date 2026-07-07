#!/bin/bash
# Download aller alten ZAP-Prüfungen Kurzgymnasium (Kanton Zürich), 2015-2025
# Quelle: https://www.zh.ch/de/bildung/schulen/maturitaetsschule/zentrale-aufnahmepruefung/pruefung-fuer-das-kurzgymnasium.html
# Ausführen mit: bash gymi_kurzgymnasium_downloads.sh

BASE="https://www.zh.ch/content/dam/zhweb/bilder-dokumente/themen/bildung/schulen/maturitaetsschulen/zap"
mkdir -p gymi_kurzgymnasium/deutsch gymi_kurzgymnasium/mathematik gymi_kurzgymnasium/merkblatt
cd gymi_kurzgymnasium || exit 1

echo "=== Deutsch ==="
D="$BASE/prüfungsvorbereitung_kg/deutsch"
declare -a deutsch_files=(
  "2025_aufsatzthemen.pdf"
  "2025_textblatt.pdf"
  "2025_sprachpruefung.pdf"
  "2025_sprachpruefung_loesung.pdf"
  "2024_aufsatzthemen_kg.pdf"
  "2024_textblatt_kg.pdf"
  "2024_sprachpruefung_kg.pdf"
  "2024_sprachpruefung_loesung_kg.pdf"
  "2023_aufsatzthemen_kg_hms.pdf"
  "2023_textblatt_kg_hms.pdf"
  "2023_sprachpruefung_kg_hms.pdf"
  "2023_sprachpruefung_loesung_kg_hms.pdf"
  "2022_aufsatzthemen_kg_hms.pdf"
  "2022_textblatt_kg_hms.pdf"
  "2022_sprachpruefung_kg_hms.pdf"
  "2022_sprachpruefung_loesung_kg_hms.pdf"
  "2021_aufsatzthemen.pdf"
  "2021_textblatt.pdf"
  "2021_sprachpruefung.pdf"
  "2021_sprachprueufng.pdf"
  "2020_aufsatzthemen_kg.pdf"
  "2020_textblatt_kg.pdf"
  "2020_sprachpruefung_kg1.pdf"
  "2020_sprachpruefung_kg.pdf"
  "2019_aufsatzthemen_kg.pdf"
  "2019_textblatt_kg.pdf"
  "2019_sprachpruefung_kg.pdf"
  "2019_sprachpruefung_loesung_kg.pdf"
  "2018_aufsatzthemen_kg.pdf"
  "2018_textblatt_kg.pdf"
  "2018_sprachpruefung_kg.pdf"
  "2018_sprachpruefung_loesung_kg.pdf"
  "2017_aufsatzthemen_kg.pdf"
  "2017_textblatt_kg.pdf"
  "2017_sprachpruefung_kg.pdf"
  "2017_sprachpruefung_loesung_kg.pdf"
  "2016_aufsatzthemen_kg.pdf"
  "2016_textblatt_kg.pdf"
  "2016_sprachpruefung_kg.pdf"
  "2016_sprachpruefung_loesung_kg.pdf"
  "2015_aufsatzthemen_kg.pdf"
  "2015_textblatt_kg.pdf"
  "2015_sprachpruefung_kg.pdf"
  "2015_sprachpruefung_loesung_kg.pdf"
)
for f in "${deutsch_files[@]}"; do
  echo "-> $f"
  curl -sSL -o "deutsch/$f" "$D/$f"
done

echo "=== Mathematik ==="
M="$BASE/prüfungsvorbereitung_kg/mathematik"
declare -a mathe_files=(
  "2025_mathematik_aufgaben.pdf"
  "2025_mathematik_loesung.pdf"
  "2024_mathematik_aufgaben_kg.pdf"
  "2024_mathematik_loesung_kg.pdf"
  "2023_mathematik_aufgaben_kg.pdf"
  "2023_mathematik_loesung_kg.pdf"
  "2022_mathematik_aufgaben_kg.pdf"
  "2022_mathematik_loesungen_kg.pdf"
  "2021_mathematik_aufgaben.pdf"
  "2021_mathematik_loesungen_kg.pdf"
  "2020_mathematik_aufgaben_kg.pdf"
  "2020_mathematik_loesungen_kg1.pdf"
  "2019_mathematik_aufgaben_kg.pdf"
  "2019_mathematik_loesung_kg.pdf"
  "2018_mathematik_aufgaben_kg.pdf"
  "2018_mathematik_loesung_kg.pdf"
  "2017_mathematik_aufgaben_kg.pdf"
  "2017_mathematik_loesung_kg.pdf"
  "2016_mathematik_aufgaben_kg.pdf"
  "2016_mathematik_loesung_kg.pdf"
  "2015_mathematik_aufgaben_kg.pdf"
  "2015_mathematik_loesung_kg.pdf"
)
for f in "${mathe_files[@]}"; do
  echo "-> $f"
  curl -sSL -o "mathematik/$f" "$M/$f"
done

echo "=== Weitere Merkblätter ==="
curl -sSL -o "merkblatt/pruefungsanforderungen_zap2_zap3_ims_august2022.pdf" \
  "$BASE/prüfungsanforderungen-zap/pruefungsanforderungen_zap2_zap3_ims_august2022.pdf"
curl -sSL -o "merkblatt/empfehlungsformular_sek_b.pdf" \
  "$BASE/empfehlungsformular_sek_b.pdf"
curl -sSL -o "merkblatt/erlaubte_taschenrechner_zap_2026.pdf" \
  "$BASE/erlaubte_taschenrechner_zap_2026.pdf"

echo "Fertig! Alle Dateien liegen in ./gymi_kurzgymnasium/"
