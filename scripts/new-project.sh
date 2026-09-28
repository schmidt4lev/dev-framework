#!/usr/bin/env bash
#
# new-project.sh – erzeugt ein neues Projekt aus dem dev-framework-Template.
#
# Kopiert den Inhalt von template/ in ein neues Verzeichnis, ersetzt die
# Platzhalter {{PROJECT_NAME}}, {{PROJECT_SLUG}}, {{OWNER}}, {{DATE}} und
# {{FRAMEWORK_VERSION}}, vermerkt die Framework-Version in .framework-version
# und legt ein Git-Repository mit Initial-Commit auf main an.
#
# Aufruf:
#   scripts/new-project.sh <zielverzeichnis> "<Projektname>" [--owner "<Name>"] [--no-git]
#
# Parameter:
#   zielverzeichnis  Pfad des neuen Projekts. Darf nicht existieren oder muss leer sein.
#                    Der letzte Pfadteil wird als PROJECT_SLUG verwendet (z. B. für Loki-Labels).
#   Projektname      Lesbarer Name, erscheint in Überschriften und Diagrammen.
#   --owner          Service Owner. Standard: git config user.name, sonst "TODO".
#   --no-git         Kein Git-Repository anlegen (z. B. wenn das Ziel schon ein Checkout ist).
#
# Exit-Codes:
#   0  Projekt erzeugt
#   1  Aufruf- oder Validierungsfehler, es wurde nichts geschrieben
#   2  Fehler beim Erzeugen, das Zielverzeichnis kann unvollständig sein
#
# Abhängigkeiten: bash >= 3.2 (macOS-Standard), git, sed, find. Kein GNU-spezifisches
# sed -i, damit das Skript unter Linux und macOS gleich läuft.

set -euo pipefail

# Framework-Wurzel relativ zum Skript bestimmen, damit der Aufruf aus jedem
# Arbeitsverzeichnis funktioniert.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRAMEWORK_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TEMPLATE_DIR="${FRAMEWORK_ROOT}/template"

usage() {
  sed -n '10,19p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

die() {
  # Meldung auf stderr und Abbruch mit dem übergebenen Exit-Code (Standard 1).
  echo "Fehler: $1" >&2
  exit "${2:-1}"
}

# --- Argumente lesen ---------------------------------------------------------

TARGET=""
PROJECT_NAME=""
OWNER=""
INIT_GIT=1

while [ $# -gt 0 ]; do
  case "$1" in
    --owner)
      [ $# -ge 2 ] || die "--owner braucht einen Wert"
      OWNER="$2"
      shift 2
      ;;
    --no-git)
      INIT_GIT=0
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      die "unbekannte Option: $1"
      ;;
    *)
      # Positionsparameter in fester Reihenfolge: erst Ziel, dann Name.
      if [ -z "$TARGET" ]; then
        TARGET="$1"
      elif [ -z "$PROJECT_NAME" ]; then
        PROJECT_NAME="$1"
      else
        die "zu viele Argumente: $1"
      fi
      shift
      ;;
  esac
done

if [ -z "$TARGET" ] || [ -z "$PROJECT_NAME" ]; then
  usage >&2
  exit 1
fi

# --- Validieren, bevor irgendetwas geschrieben wird ---------------------------

[ -d "$TEMPLATE_DIR" ] || die "Template-Verzeichnis nicht gefunden: $TEMPLATE_DIR"
[ -f "${FRAMEWORK_ROOT}/VERSION" ] || die "VERSION-Datei fehlt im Framework"

# Ein nicht leeres Ziel wird nie überschrieben, damit kein bestehendes Projekt
# versehentlich mit Template-Dateien vermischt wird.
if [ -e "$TARGET" ]; then
  [ -d "$TARGET" ] || die "Ziel existiert und ist kein Verzeichnis: $TARGET"
  if [ -n "$(ls -A "$TARGET")" ]; then
    die "Zielverzeichnis ist nicht leer: $TARGET"
  fi
fi

# Die Framework-Version ohne Zeilenumbruch und Leerzeichen einlesen.
FRAMEWORK_VERSION="v$(tr -d '[:space:]' < "${FRAMEWORK_ROOT}/VERSION")"
TODAY="$(date +%Y-%m-%d)"

# Slug aus dem letzten Pfadteil: Kleinbuchstaben, alles außer a-z0-9 wird zu "-".
# Er dient als technischer Bezeichner (Loki-Label, Container-Name).
PROJECT_SLUG="$(basename "$TARGET" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\{1,\}/-/g; s/^-//; s/-$//')"
[ -n "$PROJECT_SLUG" ] || die "aus dem Zielverzeichnis lässt sich kein Slug ableiten: $TARGET"

if [ -z "$OWNER" ]; then
  OWNER="$(git config user.name 2>/dev/null || true)"
  OWNER="${OWNER:-TODO}"
fi

# --- Hilfsfunktionen ---------------------------------------------------------

escape_sed_replacement() {
  # Maskiert Zeichen, die in der Ersetzung von sed eine Bedeutung haben:
  # "\" (Escape), "&" (gesamter Treffer) und "|" (hier als Trenner verwendet).
  # Ohne das würde ein Projektname wie "Monitoring & Alerting" verfälscht.
  printf '%s' "$1" | sed 's/[\\&|]/\\&/g'
}

replace_placeholders() {
  # Ersetzt alle Platzhalter in einer Datei. Schreibt über eine temporäre Datei
  # statt sed -i, weil sich GNU- und BSD-sed bei -i unterscheiden.
  local file="$1"
  local tmp="${file}.tmp.$$"
  sed \
    -e "s|{{PROJECT_NAME}}|$(escape_sed_replacement "$PROJECT_NAME")|g" \
    -e "s|{{PROJECT_SLUG}}|$(escape_sed_replacement "$PROJECT_SLUG")|g" \
    -e "s|{{OWNER}}|$(escape_sed_replacement "$OWNER")|g" \
    -e "s|{{DATE}}|${TODAY}|g" \
    -e "s|{{FRAMEWORK_VERSION}}|${FRAMEWORK_VERSION}|g" \
    "$file" > "$tmp"
  # cat statt mv, damit Dateirechte (z. B. ausführbare Skripte) erhalten bleiben.
  cat "$tmp" > "$file"
  rm -f "$tmp"
}

# --- Erzeugen ----------------------------------------------------------------

# Ab hier kann ein Fehler ein halb erzeugtes Ziel hinterlassen; Exit-Code 2
# signalisiert das dem Aufrufer.
trap 'echo "Fehler beim Erzeugen, Zielverzeichnis prüfen: $TARGET" >&2; exit 2' ERR

mkdir -p "$TARGET"
# "template/." kopiert auch versteckte Dateien und Verzeichnisse (.claude, .github).
cp -R "${TEMPLATE_DIR}/." "$TARGET/"

# Nur Textdateien bearbeiten. Das Template enthält derzeit keine Binärdateien;
# grep -I überspringt sie trotzdem, falls später welche hinzukommen.
find "$TARGET" -type f -not -path '*/.git/*' | while IFS= read -r file; do
  if grep -Iq . "$file"; then
    replace_placeholders "$file"
  fi
done

# Herkunft festhalten, damit spätere Framework-Updates gezielt verglichen werden können
# (siehe README des Frameworks, Abschnitt "Framework-Updates übernehmen").
printf '%s\n' "$FRAMEWORK_VERSION" > "${TARGET}/.framework-version"

if [ "$INIT_GIT" -eq 1 ]; then
  git -C "$TARGET" init -q
  # Branch explizit setzen statt "git init -b", das erst ab git 2.28 existiert.
  git -C "$TARGET" symbolic-ref HEAD refs/heads/main
  git -C "$TARGET" add -A
  # Ohne Git-Identität schlägt der Commit fehl; dann bleibt der Stand nur gestaged,
  # statt das ganze Skript abzubrechen.
  if git -C "$TARGET" config user.email >/dev/null 2>&1; then
    git -C "$TARGET" commit -q -m "chore: Projekt aus dev-framework ${FRAMEWORK_VERSION} erzeugt"
  else
    echo "Hinweis: keine Git-Identität konfiguriert, Dateien sind nur gestaged." >&2
  fi
fi

trap - ERR

cat <<EOF
Projekt "${PROJECT_NAME}" erzeugt in: ${TARGET}
Framework-Version: ${FRAMEWORK_VERSION} · Service Owner: ${OWNER}

Nächste Schritte:
  1. Leeres Repository auf GitHub anlegen und als origin hinzufügen:
       git -C "${TARGET}" remote add origin <url> && git -C "${TARGET}" push -u origin main
  2. Optional: Repository-Variable RUNNER_LABEL für den zentralen Runner setzen.
  3. Claude Code im Projekt starten und /kickoff ausführen.
EOF
