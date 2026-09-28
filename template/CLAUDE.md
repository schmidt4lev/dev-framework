# CLAUDE.md – {{PROJECT_NAME}}

Diese Datei lädt Claude Code in jeder Session automatisch. Sie enthält die Regeln, die immer gelten. Details stehen im Playbook unter `docs/engineering/PLAYBOOK.md`; das Playbook ist vor Phase 0, vor jedem neuen Arbeitspaket und bei Unklarheiten zu lesen.

## Rolle

Du arbeitest in diesem Projekt nicht als Einzelprogrammierer, sondern nach dem Prozess eines Engineering-Teams: Anforderungen und Risiken klären, Architektur festlegen, Arbeit in Pakete schneiden, dann umsetzen, prüfen, dokumentieren. Du schreibst keinen Produktivcode, solange das zugehörige Arbeitspaket unter `docs/workpackages/` nicht existiert und keinen Plan enthält.

Die Rollen Architect, Engineer, Reviewer, Security Auditor und Documentation sind als Subagents in `.claude/agents/` definiert. Nutze Reviewer, Security Auditor und Documentation vor jedem Pull Request auf den eigenen Diff. Sie laufen mit frischem Kontext und sind damit eine echte zweite Sicht.

## Projektsteckbrief

Service Owner: {{OWNER}}
Erzeugt aus dev-framework {{FRAMEWORK_VERSION}} am {{DATE}}
Stack: TODO(kickoff) – Sprache, Laufzeit, wichtigste Bibliotheken, festgelegt in ADR-0002
Zielumgebung: TODO(kickoff) – wo und wie das Projekt läuft

## Befehle

TODO(kickoff): Nach der Stack-Entscheidung hier die echten Befehle eintragen und in `.github/workflows/ci.yml` übernehmen.

Abhängigkeiten installieren: `TODO`
Lint und Format: `TODO`
Tests: `TODO`
Lokal starten: `TODO`

## Wissensbasis

Die folgenden Dateien sind die einzige verlässliche Quelle für den Projektstand. Chatverläufe sind es nicht. Was nicht in diesen Dateien steht, gilt als nicht entschieden.

`PROJECT_STATE.md` – aktueller Stand, laufende Arbeitspakete, Blocker, nächste Schritte
`ARCHITECTURE.md` – Ziele, Randbedingungen, Bausteine, Betrieb, Querschnittsthemen
`DECISIONS.md` – Index aller Architekturentscheidungen, Details in `docs/adr/`
`ROADMAP.md` – Meilensteine und Reihenfolge der Arbeitspakete
`docs/workpackages/` – ein Dokument pro Arbeitspaket mit Plan, Status und Ergebnis
`docs/operations/RUNBOOK.md` – Betrieb, Monitoring, Störungsbehebung
`docs/security/THREAT_MODEL.md` – Bedrohungen und Gegenmaßnahmen
`docs/engineering/CODING_STANDARDS.md` – Kommentarpflicht und Code-Regeln

Aktueller Projektstand:

@PROJECT_STATE.md

## Harte Regeln

1. Kein Code ohne Arbeitspaket mit Plan. Ausnahme: nichts.
2. Änderungsklasse (S, M, L) im Arbeitspaket festlegen. Klasse L braucht ein ADR und eine aktualisierte `ARCHITECTURE.md`, bevor Code entsteht. Im Zweifel die höhere Klasse.
3. Ein Thread bearbeitet genau ein Arbeitspaket auf genau einem Branch `wp/WP-<nr>-<kurzname>` und liefert genau einen Pull Request.
4. `PROJECT_STATE.md` und `ROADMAP.md` ändert nur der Planungs-Thread. Umsetzungs-Threads pflegen ihren Status ausschließlich in der eigenen Arbeitspaket-Datei.
5. Jede Änderung mit Wirkung auf Verhalten, Schnittstellen oder Betrieb bekommt einen Eintrag unter „Unreleased“ in `CHANGELOG.md`.
6. Jede Datei, jede öffentliche Funktion und jede nicht offensichtliche Stelle wird nach `docs/engineering/CODING_STANDARDS.md` kommentiert. Kommentare erklären das Warum, nicht das Was.
7. Keine Secrets, Tokens, Passwörter oder internen Zugangsdaten im Repository, in Logs oder in Beispielen. Konfiguration kommt aus der Umgebung, Beispiele stehen in `.env.example`.
8. Jeder Punkt der Definition of Done im PR-Template wird erfüllt oder mit „n/a, weil …“ begründet.
9. Du mergest nicht selbst nach `main`. Freigaben G1, G2 und G3 erteilt der Service Owner.
10. Wenn eine Anforderung unklar ist, triffst du eine begründete Annahme, schreibst sie ins Arbeitspaket und machst weiter. Nur wenn die Annahme ein Ergebnis betrifft, das nicht rückgängig zu machen ist, fragst du vorher.

## Session-Start

Lies zu Beginn jeder Session `PROJECT_STATE.md` (oben eingebunden) und, falls du an einem Arbeitspaket arbeitest, dessen Datei. Prüfe mit `git status` und `git log -5`, ob der lokale Stand zur Datei passt. Wenn nicht, gilt der Git-Stand, und du korrigierst die Datei im Rahmen deines Arbeitspakets.

## Session-Ende

Bevor du eine Session beendest oder einen Pull Request öffnest, aktualisierst du den Abschnitt „Status“ und „Übergabe“ in deiner Arbeitspaket-Datei so, dass ein neuer Thread ohne Rückfrage weitermachen kann.
