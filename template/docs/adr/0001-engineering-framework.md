# ADR-0001: Projekt nach dev-framework {{FRAMEWORK_VERSION}} führen

Status: angenommen
Datum: {{DATE}}
Entscheider: {{OWNER}}

## Kontext

Das Projekt soll über viele Sessions und parallele Claude-Threads hinweg konsistent, nachvollziehbar und betreibbar entwickelt werden. Wissen darf nicht nur in Chatverläufen liegen.

## Optionen

Erstens freies Arbeiten ohne festen Prozess: schnell im Einstieg, aber Entscheidungen und Stand gehen zwischen Sessions verloren. Zweitens ein eigener Prozess pro Projekt: passgenau, aber jedes Mal neu zu erfinden und nicht vergleichbar. Drittens das gemeinsame dev-framework: einheitliche Struktur, Rollen und Definition of Done über alle Projekte, mit dokumentierten Abweichungen.

## Entscheidung

Das Projekt wird nach dev-framework {{FRAMEWORK_VERSION}} geführt, weil es Stand und Entscheidungen im Repository hält und über Projekte hinweg einheitlich ist.

## Konsequenzen

Vor Code stehen Arbeitspaket und Plan, bei größeren Änderungen ADR und Architekturupdate. Das kostet bei kleinen Änderungen etwas Zeit, die Änderungsklassen im Playbook begrenzen den Aufwand. Abweichungen vom Playbook werden per ADR begründet. Framework-Updates werden bewusst übernommen, nicht automatisch.
