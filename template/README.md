# {{PROJECT_NAME}}

TODO(kickoff): Ein bis zwei Sätze, was das Projekt tut und für wen.

Service Owner: {{OWNER}} · Status: siehe [PROJECT_STATE.md](PROJECT_STATE.md) · Änderungen: siehe [CHANGELOG.md](CHANGELOG.md)

## Anleitung

### Voraussetzungen

TODO: Laufzeit, Werkzeuge und Versionen, Zugänge.

### Installation

```sh
# TODO: Schritte, die von einem frischen Checkout zu einem lauffähigen Stand führen
```

### Konfiguration

Die Konfiguration erfolgt über Umgebungsvariablen. Alle Variablen mit Bedeutung und Beispielwert stehen in [.env.example](.env.example). Die echte `.env` wird nie eingecheckt.

| Variable | Pflicht | Bedeutung |
|---|---|---|
| TODO | ja | TODO |

### Nutzung

TODO: Die häufigsten Aufrufe oder Bedienschritte mit Beispiel.

### Betrieb

Deployment, Monitoring, Rollback und Störungsbehebung stehen im [Runbook](docs/operations/RUNBOOK.md).

## Entwicklung

Das Projekt wird nach dem Engineering-Playbook aus dev-framework {{FRAMEWORK_VERSION}} geführt. Vor jeder Änderung gilt: Arbeitspaket unter `docs/workpackages/` anlegen, planen, dann umsetzen. Einstieg für Menschen und für Claude:

| Datei | Inhalt |
|---|---|
| [CLAUDE.md](CLAUDE.md) | Regeln für Claude Code, Befehle, Projektsteckbrief |
| [docs/engineering/PLAYBOOK.md](docs/engineering/PLAYBOOK.md) | Phasen, Rollen, Freigaben, Definition of Done |
| [docs/engineering/CODING_STANDARDS.md](docs/engineering/CODING_STANDARDS.md) | Kommentarpflicht und Code-Regeln |
| [ARCHITECTURE.md](ARCHITECTURE.md) | Architektur und Architekturbilder |
| [DECISIONS.md](DECISIONS.md) | Index der Architekturentscheidungen |
| [ROADMAP.md](ROADMAP.md) | Meilensteine und Arbeitspakete |
| [PROJECT_STATE.md](PROJECT_STATE.md) | aktueller Stand |

Claude-Befehle in diesem Repository: `/kickoff`, `/plan`, `/wp-start`, `/adr`, `/pre-pr`, `/release`.
