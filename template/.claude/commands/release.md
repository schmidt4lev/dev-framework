---
description: Release vorbereiten – Changelog versionieren und Tag vorschlagen
argument-hint: major | minor | patch
---

Bereite ein Release vor. Gewünschte Stufe: $ARGUMENTS (ohne Angabe aus den Einträgen unter „Unreleased“ nach Semantic Versioning ableiten und begründen).

Lege den Branch `release/v<version>` an. Verschiebe die Einträge unter „Unreleased“ in `CHANGELOG.md` in einen neuen Abschnitt `## [<version>] - <datum>` und lass „Unreleased“ leer stehen. Aktualisiere `PROJECT_STATE.md` (Abschnitt „Letzte Änderungen“). Öffne einen Pull Request. Den Tag `v<version>` setzt der Service Owner nach dem Merge, oder du setzt ihn, wenn er es ausdrücklich freigibt.
