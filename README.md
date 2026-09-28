# dev-framework

Standardvorlage für Projekte, die mit Claude Code als Engineering-Team entwickelt werden. Jedes neue Projekt bekommt dieselbe Struktur, dieselben Rollen, dieselben Freigaben und dieselbe Definition of Done. Projektwissen liegt im Repository, nicht in Chatverläufen, damit jede neue Session und jeder parallele Thread ohne Vorgeschichte weiterarbeiten kann.

Warum das Framework so aufgebaut ist und wo die ursprünglichen Anforderungen geschärft wurden, steht in [docs/ANFORDERUNGEN.md](docs/ANFORDERUNGEN.md).

## Aufbau

Das Repository trennt das Framework von der Vorlage, die in neue Projekte kopiert wird. Dadurch hat das Framework einen eigenen Changelog und eine eigene Version, und erzeugte Projekte beginnen mit einem leeren, eigenen Changelog.

| Pfad | Inhalt |
|---|---|
| `template/` | Die Projektvorlage. Alles darin wird beim Erzeugen kopiert. |
| `scripts/new-project.sh` | Erzeugt ein Projekt aus der Vorlage und ersetzt die Platzhalter. |
| `docs/ANFORDERUNGEN.md` | Geprüfte Anforderungen und Begründung der Regeln. |
| `VERSION`, `CHANGELOG.md` | Version und Änderungshistorie des Frameworks. |
| `.github/workflows/framework-ci.yml` | Prüft Generator und Vorlage bei jeder Änderung. |

Die Vorlage enthält:

| Datei | Zweck |
|---|---|
| `CLAUDE.md` | Regeln, die Claude Code in jeder Session lädt; bindet `PROJECT_STATE.md` automatisch ein |
| `ARCHITECTURE.md` | Architektur nach verkürztem arc42 mit Architekturbildern als Mermaid-Diagramme |
| `DECISIONS.md`, `docs/adr/` | Index und Einzeldokumente der Architekturentscheidungen |
| `ROADMAP.md` | Meilensteine und Reihenfolge der Arbeitspakete |
| `PROJECT_STATE.md` | Aktueller Stand, Einstieg für jede neue Session |
| `README.md` | Anleitung des neuen Projekts: Installation, Konfiguration, Nutzung, Betrieb |
| `CHANGELOG.md` | Changelog des neuen Projekts nach Keep a Changelog |
| `docs/engineering/PLAYBOOK.md` | Phasen, Rollen, Freigaben, Änderungsklassen, parallele Threads, Definition of Done |
| `docs/engineering/CODING_STANDARDS.md` | Kommentarpflicht und Code-Regeln |
| `docs/workpackages/` | Vorlage und erstes Arbeitspaket (Kickoff) |
| `docs/operations/RUNBOOK.md` | Betriebsdokumentation mit Checkmk, Loki, Grafana, Semaphore |
| `docs/security/THREAT_MODEL.md` | Bedrohungen und Gegenmaßnahmen nach STRIDE |
| `.claude/agents/` | Subagents: architect, engineer, reviewer, security-auditor, docs-writer |
| `.claude/commands/` | Befehle: `/kickoff`, `/plan`, `/wp-start`, `/adr`, `/pre-pr`, `/release` |
| `.claude/settings.json` | Verbietet Claude das Lesen von `.env` und `secrets/` |
| `.github/` | CI mit Secret-Scan und Changelog-Prüfung, PR-Template mit Definition of Done |

## Neues Projekt anlegen

Voraussetzungen sind bash, git und ein lokaler Klon dieses Repositories. Unter Windows läuft das Skript in Git Bash oder WSL.

```sh
git clone https://github.com/schmidt4lev/dev-framework.git
cd dev-framework
scripts/new-project.sh ../mein-projekt "Mein Projekt" --owner "Vorname Nachname"
```

Das Skript kopiert die Vorlage, setzt Projektname, Slug, Service Owner, Datum und Framework-Version ein, schreibt die Version nach `.framework-version` und legt ein Git-Repository mit Initial-Commit auf `main` an. In ein bestehendes, nicht leeres Verzeichnis schreibt es nie.

Danach das Projekt auf GitHub anlegen (leer, ohne README), als `origin` eintragen und pushen. Für den zentralen Runner die Repository-Variable `RUNNER_LABEL` auf dessen Label setzen; ohne sie läuft die CI auf `ubuntu-latest`. Anschließend Claude Code im Projekt starten und `/kickoff` ausführen.

## Arbeitsweise im Projekt

Der Ablauf in Kurzform: `/kickoff` klärt Anforderungen, Risiken und Stack. Der Architect beschreibt die Architektur samt Architekturbildern, und der Service Owner gibt sie frei (G1). `/plan` schneidet die Arbeit in Arbeitspakete, die wieder freigegeben werden (G2). Dann läuft jedes Arbeitspaket in einem eigenen Thread mit `/wp-start WP-<nr>`, auf einem eigenen Branch und mit einem eigenen Pull Request. Vor dem Pull Request prüfen Reviewer, Security Auditor und Documentation den Diff mit `/pre-pr`. Der Service Owner merged (G3). Ein Planungs-Thread hält danach `PROJECT_STATE.md` und `ROADMAP.md` aktuell.

Mehrere Threads können parallel arbeiten, solange ihre Arbeitspakete verschiedene Dateien betreffen. Die Regeln dafür stehen im Playbook in Abschnitt 5.

## Framework weiterentwickeln

Änderungen am Framework laufen selbst über Pull Requests und bekommen einen Eintrag in `CHANGELOG.md`. Nach dem Merge wird `VERSION` erhöht und ein Tag `v<version>` gesetzt. Die Framework-CI erzeugt dabei jedes Mal ein Testprojekt und prüft, dass alle Platzhalter ersetzt und alle Pflichtdateien vorhanden sind.

Platzhalter in der Vorlage haben zwei Formen. `{{PROJECT_NAME}}`, `{{PROJECT_SLUG}}`, `{{OWNER}}`, `{{DATE}}` und `{{FRAMEWORK_VERSION}}` ersetzt das Skript. `TODO(kickoff)`, `TODO(plan)` und `TODO` markieren Inhalte, die im Projekt selbst erarbeitet werden.

## Framework-Updates in bestehende Projekte übernehmen

Updates werden nicht automatisch übertragen, weil jedes Projekt die Vorlage anpasst und ein automatischer Abgleich diese Anpassungen überschreiben würde. Stattdessen zeigt Git, was sich zwischen der Version des Projekts und der aktuellen Version geändert hat:

```sh
# im Klon des Frameworks; v0.1.0 durch den Inhalt von .framework-version des Projekts ersetzen
git diff v0.1.0 HEAD -- template/
```

Relevant sind vor allem Playbook, Coding Standards, Subagents, Befehle und CI. Die Übernahme ist ein normales Arbeitspaket im Projekt; danach wird `.framework-version` aktualisiert.
