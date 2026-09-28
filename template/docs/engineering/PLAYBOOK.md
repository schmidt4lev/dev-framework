# Engineering-Playbook

Quelle: dev-framework {{FRAMEWORK_VERSION}}. Projektspezifische Abweichungen von diesem Playbook sind erlaubt, werden aber per ADR begründet und hier am Ende unter „Abweichungen“ vermerkt.

Das Playbook beschreibt, wie in diesem Projekt gearbeitet wird: in welchen Phasen, mit welchen Rollen, mit welchen Freigaben und nach welcher Definition of Done. Es richtet sich an Claude und an Menschen gleichermaßen.

## 1. Phasen und Freigaben

Jedes Projekt durchläuft einmal die Phasen 0 bis 2 und danach beliebig oft die Phasen 3 und 4. Wenn sich während der Umsetzung herausstellt, dass Architektur oder Plan nicht mehr tragen, geht die Arbeit bewusst zurück in Phase 1 oder 2. Das ist kein Scheitern, sondern der vorgesehene Weg.

**Phase 0 – Kickoff.** Der Architect erfasst Ziele, Nutzer, Randbedingungen, Qualitätsziele und die größten Risiken. Ergebnis sind die Abschnitte 1 und 2 in `ARCHITECTURE.md`, ein erster Eintrag in `docs/security/THREAT_MODEL.md` und ADR-0002 zur Stack-Wahl. Offene Fragen, die nur der Service Owner beantworten kann, stehen gesammelt in `PROJECT_STATE.md`. Auslöser: `/kickoff`.

**Phase 1 – Architektur.** Der Architect beschreibt Kontext, Lösungsstrategie, Bausteine, Verteilung und Querschnittskonzepte und legt die Architekturbilder als Mermaid-Diagramme in `ARCHITECTURE.md` an. Jede tragende Entscheidung wird ein ADR. Abschluss mit **Freigabe G1** durch den Service Owner: Anforderungen und Architektur sind akzeptiert.

**Phase 2 – Planung.** Der Architect schneidet die Arbeit in Arbeitspakete (`docs/workpackages/WP-<nr>-<kurzname>.md`) und ordnet sie in `ROADMAP.md` zu Meilensteinen. Ein Arbeitspaket ist so klein, dass es in einem Pull Request reviewbar ist, und so abgegrenzt, dass zwei parallel laufende Pakete nicht dieselben Module ändern. Abschluss mit **Freigabe G2**: Schnitt und Reihenfolge sind akzeptiert. Auslöser: `/plan`.

**Phase 3 – Umsetzung.** Pro Arbeitspaket ein Thread, ein Branch, ein Pull Request. Ablauf siehe Abschnitt 4. Abschluss mit **Freigabe G3**: Der Service Owner reviewt und merged den Pull Request.

**Phase 4 – Integration und Release.** Der Planungs-Thread aktualisiert nach jedem Merge `PROJECT_STATE.md` und `ROADMAP.md`. Bei einem Release werden die Einträge unter „Unreleased“ in `CHANGELOG.md` einer Version zugeordnet, die Version nach Semantic Versioning erhöht und ein Git-Tag `v<version>` gesetzt. Auslöser: `/release`.

## 2. Änderungsklassen

Nicht jede Änderung braucht den vollen Prozess. Die Klasse wird im Arbeitspaket festgelegt und begründet. Im Zweifel gilt die höhere.

| Klasse | Typische Änderung | Pflicht vor dem Code |
|---|---|---|
| S | Bugfix, Textänderung, kleine Anpassung ohne neue Abhängigkeit | Arbeitspaket mit kurzem Plan |
| M | Neue Funktion innerhalb der bestehenden Architektur | Arbeitspaket mit ausgearbeitetem Plan, Prüfung ob `ARCHITECTURE.md` noch stimmt |
| L | Neue Komponente, neue externe Abhängigkeit, geänderte Schnittstelle, Änderung an Security, Datenhaltung oder Betrieb | ADR, aktualisierte `ARCHITECTURE.md` samt Diagramm, Prüfung durch Architect-Subagent |

Zusätzlich gibt es den Typ **Spike**: ein zeitlich begrenztes Experiment, um ein Risiko zu klären. Ein Spike liefert eine Erkenntnis im Arbeitspaket und in der Regel ein ADR. Sein Code wird nicht nach `main` gemerged.

## 3. Rollen

Die Rollen sind Claude-Code-Subagents in `.claude/agents/`. Jeder Subagent startet mit frischem Kontext und kennt nur, was man ihm übergibt, plus dieses Repository. Das macht das Review unabhängig von den Annahmen, die der implementierende Thread im Kopf hat.

**Architect** (`architect`) verantwortet Anforderungen, Architektur, Architekturbilder, ADRs, den Schnitt der Arbeitspakete und den Projektstand. Er hält die Mermaid-Diagramme in `ARCHITECTURE.md` fortlaufend aktuell: Jedes Arbeitspaket der Klasse L und jede Änderung an Bausteinen, Schnittstellen oder Verteilung aktualisiert das betroffene Diagramm im selben Pull Request.

**Engineer** (`engineer`) setzt ein Arbeitspaket nach Plan um, schreibt Tests und kommentiert den Code nach `CODING_STANDARDS.md`. In der Praxis übernimmt der Thread selbst diese Rolle; der Subagent ist für abgegrenzte Teilaufgaben gedacht.

**Reviewer** (`reviewer`) prüft den Diff gegen Plan, Coding Standards, Kommentarpflicht, Tests und Definition of Done.

**Security Auditor** (`security-auditor`) prüft den Diff auf Secrets, unsichere Eingabeverarbeitung, Rechte, Abhängigkeiten und gleicht ihn mit dem Threat Model ab.

**Documentation** (`docs-writer`) prüft, ob README, Changelog, Runbook, Architektur und Arbeitspaket den neuen Stand beschreiben, und ergänzt, was fehlt.

Der **Service Owner** ist ein Mensch. Er erteilt die Freigaben G1 bis G3, entscheidet offene Fragen und trägt die Verantwortung für den Betrieb.

### 3.1 Modellwahl pro Rolle und Thread

Grundsatz: Das stärkere Modell dort, wo ein Fehler lange nachwirkt oder teuer entdeckt wird, das günstigere dort, wo die meisten Tokens anfallen und der Rahmen schon feststeht. Architektur und Security-Prüfung erzeugen wenig Volumen, aber ihre Fehler ziehen sich durch das ganze Projekt. Die Umsetzung erzeugt den Großteil der Tokens, arbeitet aber gegen einen freigegebenen Plan.

| Rolle / Thread | Modell (Alias) | Begründung |
|---|---|---|
| Planungs-Thread, `architect` | `opus` | Entscheidungen mit Langzeitwirkung, geringes Volumen |
| Umsetzungs-Thread, `engineer` | `sonnet` | größtes Token-Volumen, Plan und Architektur sind vorgegeben |
| `reviewer` | `opus` | Fehler finden braucht mehr Urteilsvermögen als sie zu machen; ein stärkeres Modell als der Engineer ist eine echte zweite Sicht |
| `security-auditor` | `opus` | ein übersehener Befund ist der teuerste Fehler im Prozess |
| `docs-writer` | `sonnet` | Abgleich von Diff und Doku, sprachlich anspruchsvoll, aber gut eingegrenzt |

Die Aliase stehen im Feld `model` der Subagent-Dateien in `.claude/agents/` und zeigen in Claude Code immer auf die aktuelle Generation. Stand 2026-09-28 (Framework {{FRAMEWORK_VERSION}}) sind das Claude Opus 5.5 (4 USD Input / 20 USD Output je Million Tokens) und Claude Sonnet 5 (2 / 10 USD), Sonnet kostet also die Hälfte. Claude Haiku 4.5 (1 / 5 USD) eignet sich für rein mechanische Suchen und Prüfungen, aber für keine der Rollen. Claude Fable 5.1 (10 / 50 USD) wird nicht eingesetzt, auch nicht für Einzelfälle. Es kostet das 2,5-Fache von Opus, und die Entscheidung des Service Owners ist, dass Opus die Obergrenze ist. Reicht Opus für eine Aufgabe nicht, wird die Aufgabe kleiner geschnitten oder die Effort-Stufe erhöht. Bei einem Claude-Abo statt API-Abrechnung gilt dieselbe Logik, nur dass sich der Preis als schneller aufgebrauchtes Nutzungskontingent zeigt.

Das Modell eines Threads wird beim Start festgelegt (in Claude Code mit `/model`). Ein Umsetzungs-Thread wechselt auf `opus`, wenn das Arbeitspaket Klasse L hat oder wenn derselbe Fehler nach zwei Anläufen nicht behoben ist; der Wechsel wird im Arbeitspaket vermerkt. Mehr bringt in der Regel eine höhere Effort-Stufe auf demselben Modell als ein Modellwechsel mitten in der Session, weil der Prompt-Cache modellgebunden ist.

Die Zuordnung wird überprüft, wenn eine neue Modellgeneration erscheint oder wenn Reviews wiederholt Befunde finden, die der Engineer hätte vermeiden müssen.

## 4. Ablauf eines Arbeitspakets

1. Thread starten mit `/wp-start WP-<nr>`. Claude liest Arbeitspaket, `PROJECT_STATE.md`, `ARCHITECTURE.md` und die relevanten ADRs.
2. Branch `wp/WP-<nr>-<kurzname>` von aktuellem `main` anlegen.
3. Plan im Arbeitspaket prüfen und konkretisieren: betroffene Dateien, Vorgehen, Tests, Risiken. Status auf „in Arbeit“ setzen und committen, bevor Produktivcode entsteht.
4. Umsetzen in kleinen, einzeln nachvollziehbaren Commits. Commit-Nachrichten nach Conventional Commits (`feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`) mit Arbeitspaket-Nummer, zum Beispiel `feat(api): Health-Endpunkt ergänzen (WP-004)`.
5. Tests, Lint und Format lokal ausführen.
6. `/pre-pr` ausführen: Reviewer, Security Auditor und Documentation prüfen den Diff. Befunde beheben oder im Arbeitspaket begründen, warum nicht.
7. `CHANGELOG.md` unter „Unreleased“ ergänzen, Status und Übergabe im Arbeitspaket aktualisieren.
8. Pull Request öffnen und das Template vollständig ausfüllen. Der Pull Request verweist auf das Arbeitspaket.
9. Der Service Owner reviewt und merged (G3). Danach aktualisiert der Planungs-Thread Projektstand und Roadmap.

## 5. Parallele Threads

Mehrere Threads können gleichzeitig an verschiedenen Arbeitspaketen arbeiten. Damit sie sich nicht gegenseitig stören, gelten feste Regeln für gemeinsam genutzte Dateien.

| Datei | Wer ändert sie | Regel |
|---|---|---|
| `PROJECT_STATE.md`, `ROADMAP.md` | nur der Planungs-Thread | nach Merge oder Planänderung |
| `docs/workpackages/WP-*.md` | der Thread, der das Paket bearbeitet | Status liegt nur hier |
| `DECISIONS.md` | jeder, der ein ADR anlegt | ADR-Nummer vorher auf `main` reservieren (Zeile mit Status „vorgeschlagen“); bei Kollision vor dem Merge umnummerieren |
| `ARCHITECTURE.md` | Arbeitspakete der Klasse L, sonst Planungs-Thread | parallele Klasse-L-Pakete werden nacheinander gemerged |
| `CHANGELOG.md` | jeder Pull Request | nur unter „Unreleased“ ergänzen, nie bestehende Einträge umschreiben |

Überschneiden sich zwei Arbeitspakete in den betroffenen Dateien, werden sie nacheinander bearbeitet. Das legt der Architect beim Schnitt fest und vermerkt die Abhängigkeit im Arbeitspaket.

Ein neuer Thread braucht keinen Chatverlauf. Er startet mit `CLAUDE.md`, `PROJECT_STATE.md` und seiner Arbeitspaket-Datei. Steht darin nicht genug, um weiterzuarbeiten, ist das ein Mangel der Übergabe und wird im Arbeitspaket nachgetragen.

## 6. Definition of Done

Ein Arbeitspaket ist fertig, wenn jeder Punkt erfüllt oder mit „n/a, weil …“ begründet ist. Die Liste steht identisch im Pull-Request-Template.

1. Plan im Arbeitspaket ist umgesetzt, Abweichungen sind dort dokumentiert.
2. Tests decken die geänderte Kernlogik ab und laufen grün, lokal und in CI.
3. Jede neue oder geänderte Datei und Funktion ist nach `CODING_STANDARDS.md` kommentiert.
4. `CHANGELOG.md` hat einen Eintrag unter „Unreleased“.
5. README-Anleitung ist aktuell (Installation, Konfiguration, Nutzung).
6. Architektur und Architekturbilder sind aktuell, bei Klasse L liegt ein ADR vor.
7. Logging, Monitoring und Health-Check sind für neue Funktionen berücksichtigt.
8. Runbook beschreibt neue Betriebsaufgaben, Störungen und Rollback.
9. Security-Prüfung ist erfolgt, keine Secrets im Diff, Threat Model bei Bedarf ergänzt.
10. Arbeitspaket hat Status „Review“ und eine vollständige Übergabe.

## 7. Produktionsreife

Code, der nach `main` geht, ist betriebsfähig. Das heißt konkret: Konfiguration kommt aus der Umgebung und nicht aus dem Code. Logs sind strukturiert und frei von Secrets. Der Gesundheitszustand ist von außen prüfbar. Deploy und Rollback sind beschrieben und wiederholbar. Abhängigkeiten sind auf Versionen gepinnt. Fehlerfälle führen zu einer verständlichen Meldung und nicht zu einem stillen Abbruch. Prototypen gehören in einen Spike und nicht nach `main`.

## 8. Versionierung und Changelog

Versionen folgen Semantic Versioning: MAJOR bei inkompatiblen Änderungen an Schnittstellen oder Betrieb, MINOR bei neuen Funktionen, PATCH bei Fehlerbehebungen. `CHANGELOG.md` folgt „Keep a Changelog“ mit den Rubriken Added, Changed, Deprecated, Removed, Fixed, Security. Einträge beschreiben die Wirkung für Nutzer und Betrieb, nicht die interne Umsetzung.

## 9. Was CI prüft und was nicht

CI prüft auf Secrets (gitleaks), ob `CHANGELOG.md` im Pull Request geändert wurde (Ausnahme per Label `no-changelog`), und führt die stack-spezifischen Checks aus, sobald sie beim Kickoff eingetragen sind. Architekturqualität, Kommentarqualität und die Vollständigkeit der Definition of Done prüft CI nicht. Das leisten die Subagents vor dem Pull Request und der Service Owner beim Review.

## Abweichungen

Keine.
