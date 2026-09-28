# Coding Standards

Diese Regeln gelten für jeden Stack. Sprachspezifische Ergänzungen (Linter, Formatter, Docstring-Stil) werden beim Kickoff in Abschnitt 5 eingetragen.

## 1. Sprache

Bezeichner (Variablen, Funktionen, Klassen, Dateien) sind Englisch. Kommentare, Docstrings, Commit-Nachrichten und Dokumentation sind Deutsch. Abweichungen werden per ADR entschieden.

## 2. Kommentarpflicht

Der Quelltext muss für jemanden nachvollziehbar sein, der das Projekt nicht kennt und keinen Zugriff auf Chatverläufe hat. Dafür gibt es vier Pflichten.

**Dateikopf.** Jede Quelltextdatei beginnt mit einem Kommentar, der den Zweck der Datei, ihre Einordnung in die Architektur (welcher Baustein aus `ARCHITECTURE.md`) und gegebenenfalls das Arbeitspaket oder ADR nennt, auf dem sie beruht.

**Öffentliche Schnittstellen.** Jede öffentliche Funktion, Methode, Klasse, jeder Endpunkt und jedes Skript mit Aufrufparametern hat einen Docstring oder Kommentarblock mit Zweck, Parametern, Rückgabe, möglichen Fehlern und Seiteneffekten. Seiteneffekte heißt: schreibt Dateien, ruft externe Systeme, ändert globalen Zustand.

**Das Warum an nicht offensichtlichen Stellen.** Ein Kommentar ist Pflicht bei Workarounds (mit Verweis auf Ursache oder Ticket), bei Grenzwerten und magischen Zahlen, bei Sicherheitsannahmen, bei Reihenfolgeabhängigkeiten, bei bewussten Abweichungen vom üblichen Vorgehen, bei Performance-Optimierungen, die den Code weniger lesbar machen, und bei regulären Ausdrücken, die nicht trivial sind.

**Offene Punkte.** `TODO` und `FIXME` nennen immer das Arbeitspaket, in dem sie erledigt werden: `# TODO(WP-012): Retry mit Backoff statt fester Wartezeit`. Ein TODO ohne Arbeitspaket ist ein Review-Befund.

Was kein guter Kommentar ist: das Nacherzählen einer Zeile (`i += 1  # i erhöhen`), auskommentierter Code (dafür gibt es Git), Kommentare, die nach einer Änderung nicht mehr stimmen. Ein veralteter Kommentar ist schlimmer als keiner und wird im selben Pull Request korrigiert, der den Code ändert.

### Beispiel

```python
"""Abruf des Anlagenstatus aus Checkmk.

Baustein: Adapter zu externen Systemen (ARCHITECTURE.md, Abschnitt 5).
Grundlage: ADR-0004 (REST-API statt Livestatus).
"""

def fetch_host_state(host: str, timeout_s: float = 5.0) -> HostState:
    """Liest den aktuellen Status eines Hosts aus Checkmk.

    Args:
        host: Hostname genau wie in Checkmk angelegt.
        timeout_s: Abbruch nach dieser Zeit. 5 s liegen über dem
            beobachteten P99 der API (1,8 s), aber unter dem Check-Intervall.

    Returns:
        HostState mit Status und Zeitpunkt der letzten Prüfung.

    Raises:
        HostNotFound: Host ist in Checkmk nicht bekannt.
        UpstreamError: API nicht erreichbar oder Antwort nicht lesbar.
    """
    # Die API liefert bei unbekannten Hosts 200 mit leerer Liste statt 404,
    # deshalb wird das Ergebnis explizit geprüft.
    ...
```

## 3. Struktur und Stil

Funktionen haben eine Aufgabe. Wenn der Name ein „und“ braucht, sind es zwei. Fehler werden nicht verschluckt: Entweder werden sie behandelt oder mit Kontext weitergereicht. Konfiguration wird an einer Stelle gelesen und validiert, nicht verstreut im Code. Externe Aufrufe haben einen Timeout. Formatierung übernimmt ein Formatter, nicht das Review.

## 4. Tests

Getestet wird die Kernlogik und jeder behobene Fehler (Regressionstest). Tests sind lesbar und dokumentieren das erwartete Verhalten; ihr Name beschreibt den Fall. Externe Systeme werden in Unit-Tests ersetzt, in Integrationstests nur, wenn ein echter Test nicht zumutbar ist.

## 5. Stack-spezifische Regeln

TODO(kickoff): Nach ADR-0002 eintragen. Beispiele:

Python: Formatter `ruff format`, Linter `ruff check` mit Regelgruppe `D` (Docstrings, Google-Stil), Typprüfung `mypy`.
Shell: `shellcheck`, `set -euo pipefail`, Kopfkommentar mit Aufruf und Parametern.
Ansible: `ansible-lint`, jede Rolle mit `README.md` und kommentierten Defaults.
TypeScript: `eslint` mit `eslint-plugin-jsdoc`, `prettier`, `tsc --noEmit`.
