# Changelog

Alle nennenswerten Änderungen am dev-framework werden in dieser Datei festgehalten. Erzeugte Projekte haben ihren eigenen Changelog; dieser hier beschreibt Änderungen am Template und am Generator, damit bestehende Projekte entscheiden können, was sie übernehmen.

Das Format folgt [Keep a Changelog](https://keepachangelog.com/de/1.1.0/), die Versionierung [Semantic Versioning](https://semver.org/lang/de/). MAJOR bedeutet, dass sich Struktur oder Regeln so ändern, dass bestehende Projekte angepasst werden müssen.

## [Unreleased]

## [0.1.0] - 2026-09-28

### Added

- Geprüfte und geschärfte Anforderungen in `docs/ANFORDERUNGEN.md`.
- Projekt-Template mit `CLAUDE.md`, `ARCHITECTURE.md` (inkl. Architekturbildern als Mermaid), `DECISIONS.md` mit ADR-Vorlage, `ROADMAP.md`, `PROJECT_STATE.md`, `CHANGELOG.md` und README mit Anleitung.
- Engineering-Playbook mit Phasen, Freigaben G1 bis G3, Änderungsklassen, Regeln für parallele Threads und Definition of Done.
- Modellwahl pro Rolle und Thread im Playbook (Abschnitt 3.1) und als `model` in den Subagents; Opus ist die Obergrenze, Fable wird nicht genutzt.
- Coding Standards mit Kommentarpflicht.
- Subagents für Architect, Engineer, Reviewer, Security Auditor und Documentation.
- Claude-Befehle `/kickoff`, `/plan`, `/wp-start`, `/adr`, `/pre-pr`, `/release`.
- Vorlagen für Arbeitspakete, Runbook und Threat Model.
- Projekt-CI mit Secret-Scan und Changelog-Prüfung, PR-Template mit Definition of Done.
- Generator `scripts/new-project.sh` und Framework-CI mit Smoke-Test.
