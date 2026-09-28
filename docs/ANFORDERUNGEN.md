# Anforderungen an das Development Framework

Stand: 2026-09-28, Framework-Version 0.1.0

Dieses Dokument hält fest, was das Framework leisten soll, wo die ursprünglichen Anforderungen geschärft wurden und warum. Es ist die Begründung hinter dem Playbook in `template/docs/engineering/PLAYBOOK.md`. Wer das Framework ändert, prüft zuerst, ob eine Anforderung hier betroffen ist.

## 1. Zielbild

Claude Code soll in jedem Projekt nicht als Einzelprogrammierer auftreten, sondern nach einem festen Prozess arbeiten, der dem eines kleinen Engineering-Teams entspricht: erst Anforderungen und Risiken, dann Architektur, dann ein geschnittener Plan, dann Umsetzung in überprüfbaren Paketen. Wissen über Entscheidungen und Projektstand liegt im Repository und nicht in Chatverläufen. Jede neue Session, jeder neue Thread und jeder Mensch soll aus den Projektdateien allein verstehen können, wo das Projekt steht und nach welchen Regeln weitergearbeitet wird.

Die ursprüngliche Formulierung war in der Richtung richtig. Einige Punkte waren aber so absolut formuliert, dass sie in der Praxis entweder ignoriert werden oder jede kleine Änderung unverhältnismäßig teuer machen. Andere Punkte fehlten, obwohl sie für Betrieb und Auditierbarkeit entscheidend sind. Die folgenden Abschnitte gehen das einzeln durch.

## 2. Geschärfte Anforderungen

### 2.1 Architektur und Planung vor Code, aber skaliert nach Änderungsgröße

„Architektur vor Implementierung“ und „Planung vor Code“ gelten unverändert als Grundsatz. Wörtlich genommen würde das aber bedeuten, dass ein Tippfehler in einer Log-Meldung eine Architekturprüfung braucht. Deshalb unterscheidet das Playbook drei Änderungsklassen. Klasse S (Fix, kleine Anpassung innerhalb bestehender Struktur) braucht einen kurzen Plan im Arbeitspaket, aber keine Architekturarbeit. Klasse M (Feature innerhalb der bestehenden Architektur) braucht einen ausgearbeiteten Plan und die Prüfung, ob `ARCHITECTURE.md` noch stimmt. Klasse L (neue Komponente, neue Abhängigkeit, geänderte Schnittstelle, Änderung an Security oder Betrieb) braucht ein ADR und eine Aktualisierung der Architektur, bevor Code entsteht.

Die Einstufung trifft Claude und schreibt sie ins Arbeitspaket. Im Zweifel gilt die höhere Klasse.

### 2.2 Menschliche Freigaben statt reiner Selbststeuerung

In der ursprünglichen Fassung fehlte, wer eigentlich entscheidet. Ein Claude, der Anforderungen analysiert, Architektur entwirft, plant, implementiert und reviewt, kontrolliert sich am Ende selbst. Das ist für ein auditierbares Vorgehen nicht ausreichend. Das Playbook führt deshalb drei Freigabepunkte ein, an denen der Projektverantwortliche (Service Owner) entscheidet: G1 nach Anforderungen und Architektur, G2 nach dem Schnitt der Arbeitspakete, G3 beim Merge jedes Pull Requests. Claude merged nicht selbst nach `main`, solange das nicht ausdrücklich pro Projekt erlaubt ist.

### 2.3 Rollen als Subagents, Threads als Arbeitspakete

„Mehrere spezialisierte Claude-Threads für unterschiedliche Aufgaben“ klingt naheliegend, führt aber zu einem praktischen Problem: Ein Reviewer-Thread, der dauerhaft neben einem Engineer-Thread läuft, sieht den Code des anderen erst, wenn er gepusht ist, und beide schreiben potenziell in dieselben Statusdateien.

Die tragfähigere Aufteilung ist zweigeteilt. Rollen (Architect, Engineer, Reviewer, Security Auditor, Documentation) sind als Claude-Code-Subagents in `.claude/agents/` definiert. Ein Subagent läuft mit eigenem, frischem Kontext und bekommt nur den Diff und die Regeln zu sehen. Das ist genau die unabhängige zweite Sicht, die man von einem Review erwartet. Threads dagegen entsprechen Arbeitspaketen: ein Thread, ein Arbeitspaket, ein Branch, ein Pull Request. Ein eigener Planungs-Thread übernimmt Architektur, Roadmap und Projektstand.

### 2.4 Parallelität braucht Eigentumsregeln für Dateien

Sobald mehrere Threads parallel arbeiten, werden gemeinsam genutzte Dateien zum Konfliktpunkt. Das betrifft vor allem `PROJECT_STATE.md`, `ROADMAP.md`, `DECISIONS.md` und `CHANGELOG.md`. Ohne Regel überschreiben sich Threads gegenseitig oder erzeugen ständig Merge-Konflikte.

Das Playbook regelt das so: Der Status eines Arbeitspakets steht ausschließlich in dessen eigener Datei unter `docs/workpackages/`. `PROJECT_STATE.md` und `ROADMAP.md` pflegt nur der Planungs-Thread, typischerweise nach einem Merge. ADR-Nummern werden vor Arbeitsbeginn im Index `DECISIONS.md` auf `main` reserviert. `CHANGELOG.md` wird nur unter „Unreleased“ ergänzt, was sich bei Konflikten trivial auflösen lässt. Zwei parallele Arbeitspakete dürfen nicht dieselben Module ändern; wenn sich das nicht vermeiden lässt, werden sie nacheinander bearbeitet.

### 2.5 „Vollständige Dokumentation aller Entscheidungen“ wird zu „aller tragenden Entscheidungen“

Jede Entscheidung zu dokumentieren ist nicht leistbar und erzeugt Rauschen, in dem die wichtigen Entscheidungen untergehen. Pflicht ist ein ADR für jede Entscheidung, die schwer rückgängig zu machen ist oder die spätere Arbeit einschränkt: Wahl von Sprache, Framework, Datenhaltung, Schnittstellenformat, Authentifizierung, Deployment-Weg, bewusst eingegangene Risiken. Kleinere Entscheidungen stehen im Arbeitspaket. Ein ADR wird nie gelöscht, sondern nur durch ein neueres ersetzt.

### 2.6 „Jede Änderung erzeugt automatisch Doku, Tests, Monitoring“ wird zu einer Definition of Done mit Begründungspflicht

Diese Anforderung war die unrealistischste. Eine Änderung an einem README braucht keine Monitoring-Konfiguration, und „automatisch“ lässt sich für Architekturqualität oder gute Kommentare nicht technisch erzwingen. Wird so etwas trotzdem pauschal verlangt, entstehen Pflichttests ohne Aussagekraft und Monitoring-Einträge, die niemand braucht.

Stattdessen gibt es eine Definition of Done im Pull-Request-Template. Jeder Punkt (Tests, Doku, Kommentare, Changelog, Monitoring, Logging, Runbook, Security) wird entweder erfüllt oder mit „n/a, weil …“ begründet. Eine fehlende Begründung ist ein Review-Befund. Damit bleibt der Anspruch erhalten, ohne Aufwand an Stellen zu erzwingen, an denen er keinen Nutzen hat.

### 2.7 Trennung zwischen dem, was CI erzwingt, und dem, was Konvention bleibt

Ein Teil der Regeln lässt sich technisch absichern, ein anderer nur über Review. Das Framework ist hier bewusst ehrlich, damit niemand sich auf eine Prüfung verlässt, die es nicht gibt.

| Anforderung | Mechanismus | Durchsetzung |
|---|---|---|
| Keine Secrets im Repo | gitleaks in CI, `.gitignore`, Deny-Regeln in `.claude/settings.json` | technisch |
| Changelog bei jeder Änderung | CI-Check auf `CHANGELOG.md` im PR, Ausnahme per Label `no-changelog` | technisch |
| Lint, Format, Tests | CI-Job, Befehle werden beim Kickoff je Stack eingetragen | technisch, sobald eingetragen |
| Kommentarpflicht | Coding Standard, Docstring-Linter wo der Stack einen hat, Reviewer-Subagent | teilweise technisch, sonst Review |
| Architektur vor Code | Änderungsklassen, ADR-Pflicht bei Klasse L, Freigabe G1 | Konvention und Freigabe |
| Planung vor Code | Arbeitspaket-Datei muss vor dem ersten Commit existieren | Konvention und Review |
| Monitoring, Logging, Betrieb | Definition of Done, `docs/operations/RUNBOOK.md` | Review |
| Nachvollziehbarer Projektstand | `PROJECT_STATE.md`, Arbeitspaket-Dateien | Konvention |

### 2.8 Nachvollziehbarer Quelltext

Die Kommentarpflicht bleibt zentral, wird aber präzisiert, weil „immer kommentiert“ oft zu Kommentaren führt, die nur den Code nacherzählen. Pflicht sind ein Dateikopf mit Zweck und Einordnung, eine Beschreibung jeder öffentlichen Funktion und Schnittstelle (Zweck, Parameter, Rückgabe, Fehlerfälle), und ein Kommentar überall dort, wo das Warum nicht aus dem Code hervorgeht: Workarounds, Grenzwerte, Sicherheitsannahmen, Reihenfolgeabhängigkeiten, bewusste Abweichungen vom Standard. Kommentare, die nur wiederholen, was eine Zeile tut, gelten als Mangel. Details stehen in `template/docs/engineering/CODING_STANDARDS.md`.

### 2.9 Produktionsreif heißt betriebsfähig, und Prototypen sind erlaubt, aber gekennzeichnet

„Produktionsreife Ergebnisse statt Proof-of-Concept-Code“ braucht eine Definition, sonst ist es nicht prüfbar. Produktionsreif heißt im Framework: Konfiguration über Umgebung statt im Code, strukturierte Logs, ein prüfbarer Gesundheitszustand, ein dokumentierter Deploy- und Rollback-Weg, ein Runbook, kein Secret im Repository, Tests für die Kernlogik.

Gleichzeitig ist ein Verbot jedes Prototyps kontraproduktiv, weil sich manche Risiken nur durch Ausprobieren klären lassen. Deshalb gibt es den Arbeitspakettyp „Spike“. Ein Spike ist zeitlich begrenzt, liefert eine Erkenntnis und ein ADR, und sein Code wird nicht nach `main` gemerged.

### 2.10 Fehlende Anforderungen, die ergänzt wurden

Einige Punkte waren im ursprünglichen Text nicht enthalten, sind aber für langfristig betreibbare Projekte nötig. Versionierung folgt Semantic Versioning, der Changelog dem Format „Keep a Changelog“. Gearbeitet wird trunk-basiert mit kurzlebigen Branches pro Arbeitspaket. Jedes Projekt hat einen namentlich benannten Service Owner. Abhängigkeiten werden gepinnt und regelmäßig aktualisiert. Und das Framework selbst ist versioniert: Jedes erzeugte Projekt vermerkt in `.framework-version`, aus welcher Version es stammt, damit spätere Verbesserungen am Framework gezielt nachgezogen werden können.

### 2.11 Stackneutral mit Anbindung an die vorhandene Infrastruktur

Das Template legt keine Programmiersprache fest. Sprache, Linter und Testwerkzeug werden beim Kickoff per ADR entschieden und in `CLAUDE.md` sowie der CI eingetragen. Für den Betrieb setzt das Template auf die vorhandene Umgebung: GitHub Actions auf den zentralen Runnern (Runner-Label über die Repository-Variable `RUNNER_LABEL`), Checkmk für Verfügbarkeit, Loki für Logs, Grafana für Dashboards, Semaphore für Deployments. Das Runbook-Template fragt diese Punkte ab, erzwingt aber keine Integration, die für ein Projekt keinen Sinn ergibt.

### 2.12 Modellwahl nach Wirkung und Volumen

Qualität und Token-Verbrauch hängen davon ab, welches Modell welche Arbeit macht. Alles auf dem stärksten Modell laufen zu lassen ist teuer, ohne dass die Umsetzung eines freigegebenen Plans davon nennenswert profitiert. Alles auf dem günstigen Modell laufen zu lassen spart an der falschen Stelle, nämlich bei Architektur und Security, wo wenig Tokens anfallen, Fehler aber am längsten nachwirken.

Das Playbook ordnet deshalb Architect, Reviewer und Security Auditor dem Opus-Modell zu und Engineer sowie Documentation dem Sonnet-Modell, das zum Stand 2026-09-28 halb so viel kostet. Weil die Umsetzung den größten Teil der Tokens erzeugt, liegt dort auch der größte Hebel. Der Reviewer läuft bewusst auf einem stärkeren Modell als der Engineer, damit das Review nicht dieselben blinden Flecken hat. Die Zuordnung steht als Alias in den Subagent-Dateien, damit sie bei neuen Modellgenerationen ohne Änderung mitwandert, und wird bei jeder neuen Generation überprüft. Details und Eskalationsregeln stehen im Playbook in Abschnitt 3.1.

## 3. Was bewusst nicht Teil des Frameworks ist

Das Framework automatisiert keine Deployments und enthält keine fertigen Monitoring-Konfigurationen, weil diese vom Stack und vom Zielsystem abhängen. Es enthält auch keinen Mechanismus, der Framework-Updates automatisch in bestehende Projekte überträgt. Ein solcher Mechanismus würde projektspezifische Anpassungen überschreiben. Der vorgesehene Weg ist ein Vergleich der Template-Stände zwischen zwei Framework-Versionen und die bewusste Übernahme der relevanten Teile, beschrieben im README.

## 4. Offene Punkte

Ob Claude in einzelnen Projekten selbst nach `main` mergen darf, ist bewusst pro Projekt zu entscheiden und nicht im Framework festgelegt. Ebenso offen ist, ob die Code-Kommentare langfristig Deutsch bleiben sollen. Der Standard ist Deutsch für Kommentare und Dokumentation, Englisch für Bezeichner. Wer Projekte mit einem internationalen Team teilt, ändert das per ADR.
