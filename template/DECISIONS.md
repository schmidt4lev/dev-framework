# Architekturentscheidungen – {{PROJECT_NAME}}

Index aller Architecture Decision Records (ADR). Die Details stehen jeweils in `docs/adr/`. Ein ADR wird nie gelöscht oder inhaltlich umgeschrieben. Ändert sich eine Entscheidung, entsteht ein neues ADR, und das alte bekommt den Status „ersetzt durch ADR-xxxx“.

Wer ein ADR anlegen will, reserviert zuerst die nächste freie Nummer, indem er hier eine Zeile mit Status „vorgeschlagen“ auf `main` einträgt. So vergeben parallele Threads keine Nummer doppelt. Vorlage: `docs/adr/0000-vorlage.md`, Auslöser: `/adr`.

Ein ADR ist Pflicht für jede Entscheidung, die schwer rückgängig zu machen ist oder spätere Arbeit einschränkt: Sprache und Framework, Datenhaltung, Schnittstellenformate, Authentifizierung, Deployment-Weg, bewusst eingegangene Risiken.

| Nr. | Titel | Status | Datum |
|---|---|---|---|
| [ADR-0001](docs/adr/0001-engineering-framework.md) | Projekt nach dev-framework {{FRAMEWORK_VERSION}} führen | angenommen | {{DATE}} |
| ADR-0002 | Stack-Wahl | offen, Phase 0 | – |
