---
description: Phase 0 starten – Anforderungen, Randbedingungen, Risiken und Stack klären (WP-001)
---

Starte Phase 0 nach `docs/engineering/PLAYBOOK.md` und bearbeite `docs/workpackages/WP-001-kickoff.md`.

Zusätzliche Informationen vom Service Owner: $ARGUMENTS

Vorgehen: Lege den Branch `wp/WP-001-kickoff` an. Beauftrage den Subagent `architect`, die Abschnitte 1 und 2 in `ARCHITECTURE.md`, einen ersten Stand von `docs/security/THREAT_MODEL.md` und ADR-0002 zur Stack-Wahl zu erarbeiten. Trage danach die Befehle in `CLAUDE.md`, die stack-spezifischen Regeln in `docs/engineering/CODING_STANDARDS.md` Abschnitt 5 und die Checks in `.github/workflows/ci.yml` ein. Sammle offene Fragen an den Service Owner in `PROJECT_STATE.md`. Schreibe keinen Produktivcode. Schließe mit `/pre-pr` und einem Pull Request ab, dessen Merge die Freigabe G1 vorbereitet.
