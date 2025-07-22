## Eliminazione delle costanti di Hollerith 
Le costanti Hollerith (`5HNLDIV`, `4H SRC`, ecc.) sono una vecchia estensione Fortran e non sono più supportate nei compilatori moderni. Sostituiscile con stringhe standard.

## Cambio dichiarazione variabile
Assicurati che le variabili `INDATA` e `OUTDAT` siano dichiarate come `CHARACTER` e non come `REAL`

