USE agencija

SELECT * FROM Klijent

SELECT * FROM MuzickiZanr

SELECT * FROM Angazman

--Ponavljanje agencija
--1 Ispiši klijente kojima poštanski broj završava na 006
SELECT * FROM Klijent WHERE PostanskiBroj LIKE '%006'

--2 Ispiši agente koji žive u Redmondu i rade za proviziju veću od 0,2 
SELECT * FROM Agent WHERE Grad LIKE 'Redmond' AND Provizija > 0.2

--3 Ispiši angažmane koji su bili ugovoreni u 7. mjesecu 2016 i kojima je ugovorena cijena bila veća od 2000
SELECT * FROM Angazman WHERE PocetniDatum BETWEEN '2016-07-01' AND '2016-07-31' AND UgovorenaCijena > 2000

--4	Ispiši angažmane i uz svakog razliku u danima između početka i kraja (131)
SELECT *, DATEDIFF(dd, PocetniDatum, ZavrsniDatum) [Razlika] FROM Angazman

