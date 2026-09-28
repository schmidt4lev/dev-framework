---
description: Ein Arbeitspaket in diesem Thread beginnen oder fortsetzen
argument-hint: WP-<nr>
---

Bearbeite das Arbeitspaket $ARGUMENTS nach `docs/engineering/PLAYBOOK.md` Abschnitt 4.

Lies die Arbeitspaket-Datei unter `docs/workpackages/`, `PROJECT_STATE.md`, `ARCHITECTURE.md` und die dort verlinkten ADRs. Prüfe, ob die Abhängigkeiten erledigt sind; wenn nicht, brich ab und sag, worauf das Paket wartet.

Existiert der Branch `wp/WP-<nr>-<kurzname>` schon, setze dort fort und lies zuerst die Übergabe im Arbeitspaket. Sonst lege ihn von aktuellem `main` an. Konkretisiere den Plan, setze den Status auf „in Arbeit“ und committe das, bevor Produktivcode entsteht. Ändere `PROJECT_STATE.md` und `ROADMAP.md` nicht.
