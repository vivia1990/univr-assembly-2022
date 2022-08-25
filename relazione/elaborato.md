---
title: Telemetria F1
author: Michele Viviani, Pietro De Carli, Silvia Caprioli
language: it-IT
---

\newpage

# Elaborato
Si intende realizzare un programma che simuli il sistema di telemetria del videogame F1. 
Il sistema fornisce in input i dati di giri motore (rpm), temperatura motore e velocità di tutti i piloti in gara per ogni istante di tempo. 


**Il file è così composto**:

- Il separatore di ogni campo è rappresentato dalla virgola `,` 
- Ogni riga di file input risulata composta dai campi  `tempo`,  `id_pilota`,  `velocità`,  `rpm`,  `temperatura`
- Ogni pilota presente in pista possiede un proprio valore numerico identificato come id_pilota tramie la seguente tabella


ID | Nome
---|---
0  | Pierre Gasly
1  | Charles Leclerc
2  | Max Verstappen
3  | Lando Norris
4  | Sebastian Vettel
5  | Daniel Ricciardo 
6  | Lance Stroll
7  | Carlos Sainz
8  | Antonio Giovinazzi
9  | Kevin Magnussen
10 | Alexander Albon
11 | Nicholas Latifi
12 | Lewis Hamilton
13 | Romain Grosjean
14 | George Russell
15 | Sergio Perez 
16 | Daniil Kvyat
17 | Kimi Raikkonen
18 | Esteban Ocon
19 | Valteri Bottas 

## Obiettivo {.unlisted .unnumbered}
Il programma chiama una funzione assembly, `telemetry`, che restituisce come output corrispondente i soli valori del pilota indicato tramite id, delle righe così strutturate: \newline
 `tempo`,  `rpm`,  `temperatura`,  `velocità` 
\newline
\newline
Tali  valori, escluso il tempo, sono rappresentati sottoforma di stringhe `LOW`, `MEDIUM`, `HIGH` in base alla comparazione dell'input con delle soglie specificate, per ogni campo. \newline
L'ultima riga del file di output conterrà un resoconto con il numero di giri massimi, la temperatura massima rilevata, la velocità di picco e la velocità media, così strutturate: \newline
`rpm max`,  `temp max`,  `velocità max`,  `velocità media` 
\newline

Di seguito la tabella con i valori delle soglie

| **Campo**              | **Low**          | **Medium**                       |    **High**      |
| :--------------------: | ---------------- | -------------------------------- | ---------------- |
|   **Rpm**              |  $\leq 5000$     | $5000 < \text{value} \leq 10000$ |  $> 10000$       |
|   **Temperatura**      |  $\leq 90$       | $90 < \text{value} \leq 110$     |  $> 110$         |
|   **Velocità**      |  $\leq 100$      | $100 < \text{value} \leq 250$    |  $> 250$         |


