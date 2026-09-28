# Runbook – {{PROJECT_NAME}}

Betriebsdokumentation für den laufenden Dienst. Zielgruppe ist, wer nachts um drei eine Störung beheben muss und das Projekt nicht kennt. Abschnitte ohne Bezug werden mit „n/a, weil …“ begründet.

Service Owner: {{OWNER}}
Eskalation: TODO

## 1. Überblick

TODO: Was macht der Dienst, wer ist betroffen, wenn er ausfällt, wie kritisch ist das?

## 2. Deployment

TODO: Weg vom Merge bis zur Produktion. Standard: CI auf dem zentralen Runner baut und prüft, Semaphore deployt (Template bzw. Playbook: TODO). Wo liegt die Konfiguration, wo die Secrets (nicht im Repo)?

## 3. Rollback

TODO: Wie wird auf die vorherige Version zurückgegangen, und wie lange dauert das? Rollback ist vor dem ersten Produktiv-Deployment einmal zu testen.

## 4. Monitoring

| Prüfung | Werkzeug | Schwellwert | Reaktion |
|---|---|---|---|
| Dienst erreichbar / Health | Checkmk | TODO | Abschnitt 6 |
| Fehlerrate in Logs | Loki / Grafana | TODO | Abschnitt 6 |
| TODO | TODO | TODO | TODO |

Dashboards: TODO (Grafana-Link). Benachrichtigung: TODO (zum Beispiel Checkmk-Notification, Home Assistant).

## 5. Logs

TODO: Wo landen die Logs, mit welchen Labels in Loki, Beispiel-Abfrage in LogQL:

```
{app="{{PROJECT_SLUG}}"} | json | level="error"
```

## 6. Störungen und Behebung

Pro bekanntem Fehlerbild ein Abschnitt: Symptom, Ursache prüfen, Behebung, Nachweis dass behoben.

### TODO: Fehlerbild

Symptom: …
Prüfung: …
Behebung: …

## 7. Backup und Wiederherstellung

TODO: Welche Daten, wie oft, wohin, wie wird die Wiederherstellung getestet?

## 8. Wartung

TODO: Regelmäßige Aufgaben wie Updates von Abhängigkeiten, Zertifikate, Log-Rotation.
