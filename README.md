# 1. Úvod a popis zdrojových dát

V tomto projekte sa zameriavame na analýzu predaja bicyklov v rôznych regiónoch a časoch. Vybrali sme si tento dataset, pretože je prehľadný, jednoduchý na pochopenie a dá sa dobre analyzovať podľa produktov, regiónov aj času.

Dáta ukazujú, ako prebieha predaj bicyklov – zaznamenávajú jednotlivé predaje, informácie o produktoch, zákazníkoch, miestach predaja a finančné údaje. Pomáhajú nám sledovať, aké bicykle sa predávajú najviac, ktoré regióny majú najlepší predaj a ako sa predaje menia v čase.

Dataset obsahuje rôzne typy údajov: časové (dátum predaja), produktové (typ a kategória bicykla), geografické (kde sa predaj uskutočnil) a číselné (tržby, počet predaných kusov, zisk).

Analýza bude hlavne zameraná na:
* sledovanie predaja bicyklov v čase
* zistenie najpredávanejších produktov a kategórií
* porovnanie predaja medzi rôznymi regiónmi
* sledovanie trendov v tržbách a zisku

Dáta pochádzajú zo Snowflake Marketplace, konkrétne z datasetu [Bike Sales – Sample Dashboard Synthetic Data](https://app.snowflake.com/marketplace/listing/GZ1M7Z2XJQI/astrato-bike-sales-sample-dashboard-synthetic-data?search=sales).

Dataset obsahuje niekoľko tabuliek:
* SALES – údaje o jednotlivých predajoch, ako dátum, ID produktu, ID zákazníka, región, množstvo, tržby a zisk. Toto bude základ pre faktovú tabuľku.
* PRODUCTS – informácie o bicykloch, názov, kategória a podkategória. Slúži na dimenziu produktov.
* CUSTOMERS – info o zákazníkoch (ID, meno, segment). Slúži na dimenziu zákazníkov.
* GEOGRAPHY – údaje o regiónoch predaja (mestá, krajiny). Slúži na dimenziu regiónov.
* PRODUCTSUBCATEGORY – kategórie a podkategórie bicyklov, pomáhajú rozšíriť produktovú dimenziu.

Cieľom ELT procesu je tieto dáta získať zo Snowflake Marketplace, upraviť ich do dimenzionálneho modelu typu hviezda a pripraviť na analýzu a vizualizácie, aby sme mohli jednoducho sledovať predaje z rôznych uhlov pohľadu.

***

### 1.1 Dátová architektúra
### ERD diagram
Surové dáta sú usporiadané v relačnom modeli, ktorý je znázornený na entitno-relačnom diagrame (ERD):








*Obrázok 1 Entitno-relačná schéma BikeSales*
***

## 2 Dimenzionálny model







*Obrázok 2 Schéma hviezdy pre BikeSales*
***
## 3. ELT proces v Snowflake
...
...
...
### 3.1 Extract (Extrahovanie dát)
...
...
#### Príklad kódu 
`SELECT *
FROM SALES;`

### 3.2 Load (Načítanie dát)
...
...
#### Príklad kódu 
`SELECT *
FROM SALES;`

### 3.3 Transform (Transformácia dát)
...
...
#### Príklad kódu 
`SELECT *
FROM SALES;`
...
#### Príklad kódu 
`SELECT *
FROM SALES;`
...
#### Príklad kódu 
`SELECT *
FROM SALES;`
...
#### Príklad kódu 
`SELECT *
FROM SALES;`
...
#### Príklad kódu 
`SELECT *
FROM SALES;`
***

## 4 Vizualizácia dát
...
(img)
*Obrázok 3 Dashboard BikeSales datasetu*
***
### Graf 1: (názov)
(opis)
`kod`
***
### Graf 2: (názov)
(opis)
`kod`
***
### Graf 3: (názov)
(opis)
`kod`
***
### Graf 4: (názov)
(opis)
`kod`
***
### Graf 5: (názov)
(opis)
`kod`
***
### Graf 6: (názov)
(opis)
`kod`
***
Autorky: Nikola Černá a Sára Dzurechová




