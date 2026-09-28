# Threat Model – {{PROJECT_NAME}}

Gepflegt durch Architect und Security Auditor. Wird bei jeder Änderung der Klasse L und jeder neuen externen Schnittstelle geprüft.

## Schutzbedarf

TODO(kickoff): Welche Daten und Funktionen sind schützenswert, und wie hoch ist der Schaden bei Verlust von Vertraulichkeit, Integrität oder Verfügbarkeit?

## Vertrauensgrenzen

TODO: Wo kommen Daten von außen herein, wo verlassen sie das System? Die Grenzen im Kontextdiagramm in `ARCHITECTURE.md` markieren.

## Bedrohungen und Gegenmaßnahmen

Gegliedert nach STRIDE (Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege).

| Nr. | Bedrohung | Kategorie | Gegenmaßnahme | Status |
|---|---|---|---|---|
| T1 | Secrets gelangen ins Repository | Information Disclosure | gitleaks in CI, `.gitignore`, `.env.example` statt `.env` | umgesetzt |
| T2 | TODO | TODO | TODO | offen |

## Bewusst akzeptierte Risiken

Jedes akzeptierte Risiko mit Begründung und Verweis auf das ADR.
