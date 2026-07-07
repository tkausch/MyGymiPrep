#!/bin/bash
# Download aller alten ZAP-Prüfungen Langgymnasium (Kanton Zürich), 2015-2025
# Quelle: https://www.zh.ch/de/bildung/schulen/maturitaetsschule/zentrale-aufnahmepruefung/pruefung-fuer-das-langgymnasium.html
# Ausführen mit: bash gymi_langgymnasium_downloads.sh

BASE="https://www.zh.ch/content/dam/zhweb/bilder-dokumente/themen/bildung/schulen/maturitaetsschulen/zap"
mkdir -p gymi_langgymnasium/deutsch gymi_langgymnasium/mathematik gymi_langgymnasium/merkblatt
cd gymi_langgymnasium || exit 1

echo "=== Deutsch ==="
D="$BASE/prüfungsvorbereitung_lg/deutsch"
declare -a deutsch_files=(
  "2025_aufsatzthemen.pdf"
  "2025_textblatt.pdf"
  "2025_sprachpruefung.pdf"
  "2025_sprachpruefung_loesungen.pdf"
  "2024_aufsatzthemen_lg.pdf"
  "2024_textblatt_lg.pdf"
  "2024_sprachpruefung_lg.pdf"
  "2024_sprachpruefung_loesung_lg.pdf"
  "2023_aufsatzthemen_lg.pdf"
  "2023_textblatt_lg.pdf"
  "2023_sprachpruefung_lg.pdf"
  "2023_sprachpruefung_loesung_lg.pdf"
  "2022_aufsatzthemen_lg.pdf"
  "2022_textblatt_lg.pdf"
  "2022_sprachpruefung_lg.pdf"
  "2022_sprachpruefung_loesung_lg.pdf"
  "2021_aufsatzthemen.pdf"
  "2021_textblatt.pdf"
  "2021_sprachpruefung_aufgaben.pdf"
  "2021_sprachpruefung_loesung.pdf"
  "2020_aufsatzthemen_lg.pdf"
  "2020_textblatt_lg.pdf"
  "2020_sprachpruefung.pdf"
  "2020_sprachpruefung_loesung_lg.pdf"
  "2019_aufsatzthemen_lg.pdf"
  "2019_textblatt.pdf"
  "2019_sprachpruefung_aufgaben_lg.pdf"
  "2019_sprachpruefung_loesung_lg.pdf"
  "2018_aufsatzthemen.pdf"
  "2018_textblatt_lg.pdf"
  "2018_sprachpruefung_lgpdf"
  "2018_sprachpruefung_loesung_lg.pdf"
  "2017_aufsatzthemen_lg.pdf"
  "2017_textblatt_lg.pdf"
  "2017_sprachpruefung_lg.pdf"
  "2017_sprachpruefung_loesung_lg.pdf"
  "2016_aufsatzthemen_lg.pdf"
  "2016_textblatt_lg.pdf"
  "2016_textverstaendnis_teil_a.pdf"
  "2016_sprachpruefung_loesung_lgpdf"
  "2015_aufsatzthemen_lg.pdf"
  "2015_aufsatz_korrekturhinweise_lg.pdf"
  "2015_textblatt_lg.pdf"
  "2015_sprachpruefung_lg.pdf"
  "2015_sprachpruefung_loesung_lg.pdf"
)
for f in "${deutsch_files[@]}"; do
  echo "-> $f"
  curl -sSL -o "deutsch/$f" "$D/$f"
done

# echo "=== Mathematik ==="
# M="$BASE/prüfungsvorbereitung_lg/mathematik"
# declare -a mathe_files=(
#   "2025_mathematik_aufgaben.pdf"
#   "2025_mathematik_loesungen.pdf"
#   "2024_mathematik_aufgaben_lg.pdf"
#   "2024_mathematik_loesungen_lg.pdf"
#   "2023_mathematik_aufgaben_lg.pdf"
#   "2023_mathematik_loesungen_lg.pdf"
#   "2022_mathematik_aufgaben.pdf"
#   "2022_mathematik_loesungen.pdf"
#   "2021_mathematik_aufgaben.pdf"
#   "2021_mathematik_loesungen.pdf"
#   "2020_mathematik_aufgaben_lg.pdf"
#   "2020_mathematik_lg.pdf"
#   "2019_mathematik_aufgaben_lg.pdf"
#   "2019_mathematik_loesung_lg.pdf"
#   "2018_mathematik_aufgaben_lg.pdf"
#   "2018_mathematik_loesung_lg.pdf"
#   "2017_mathematik_aufgaben_lg.pdf"
#   "2017_mathematik_loesung_lg.pdf"
#   "2016_mathematik_aufgaben_lg.pdf"
#   "2016_mathematik_loesung_lg.pdf"
#   "2015_mathematik_aufgaben_lg.pdf"
#   "2015_mathematik_loesung_lg.pdf"
# )
# for f in "${mathe_files[@]}"; do
#   echo "-> $f"
#   curl -sSL -o "mathematik/$f" "$M/$f"
# done
#
# echo "=== Merkblatt: Prüfungsanforderungen ==="
# curl -sSL -o "merkblatt/pruefungsanforderungen_lg.pdf" \
#   "$BASE/prüfungsanforderungen-zap/pruefungsanforderungen_lg.pdf"

echo "Fertig! Alle Deutsch-Dateien liegen in ./gymi_langgymnasium/deutsch/"
