---
description: Prüfung vor dem Pull Request durch Reviewer, Security Auditor und Documentation
---

Prüfe den aktuellen Branch vor dem Pull Request.

Führe zuerst Tests, Lint und Format mit den Befehlen aus `CLAUDE.md` aus. Starte dann die Subagents `reviewer`, `security-auditor` und `docs-writer`, jeweils auf `git diff main...HEAD` und die Arbeitspaket-Datei des Branches. Übergib ihnen nur Diff, Arbeitspaket und Verweise auf die Regeln, nicht deine eigene Einschätzung, damit die Prüfung unabhängig bleibt.

Behebe alle blockierenden und kritischen Befunde. Für jeden Befund, den du nicht behebst, schreibst du die Begründung in den Abschnitt „Übergabe“ des Arbeitspakets. Gehe danach die Definition of Done aus `docs/engineering/PLAYBOOK.md` Punkt für Punkt durch und gib eine Übersicht aus: erfüllt, oder „n/a, weil …“.
