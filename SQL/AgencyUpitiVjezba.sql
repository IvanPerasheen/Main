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


--Više tablica, CROSS i INNER JOIN
--Primjer za CROSS JOIN
USE narudzbe
--prvo izliszamo tablicu proizvoda (42)
SELECT * FROM Proizvod
-- tablica kategorija(8)
SELECT * FROM Kategorija


--CROSS JOIN
SELECT  Proizvod.[Id], Proizvod.[Naziv], Proizvod.[Opis], Proizvod.[ProdajnaCijena], Proizvod.[Stanje], Proizvod.[IdKategorija], Kategorija.id, Kategorija.Opis 
FROM [Proizvod] CROSS JOIN Kategorija
ORDER BY Proizvod.Naziv

--INNER JOIN
SELECT  Proizvod.[Id], Proizvod.[Naziv], Proizvod.[Opis], Proizvod.[ProdajnaCijena], Proizvod.[Stanje], Proizvod.[IdKategorija], Kategorija.id, Kategorija.Opis 
FROM [Proizvod] INNER JOIN Kategorija ON Proizvod.idKategorija = Kategorija.Id
--dobili smo 40 zapisa, zato što dva proizvoda nemaju kategoriju


--VJEZBA!!!
USE agencija
--1 Ispiši podatke o agentu (ime, prezime) i datum početka i završetka angažmana koji je organizirao.
--Rezultate poredaj po datumu početka angažmana. (131)
SELECT Agent.Ime, Agent.Prezime, Angazman.PocetniDatum,Angazman.ZavrsniDatum
FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
ORDER BY Angazman.PocetniDatum
 
 --2 Proširi upit iz točke a tako da se ispisuje i naziv izvođača koji je bio angažiran. (131)
SELECT Agent.Ime, Agent.Prezime, Angazman.PocetniDatum,Angazman.ZavrsniDatum, Izvodac.Naziv
FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent INNER JOIN Izvodac ON Angazman.IdIzvodac = Izvodac.IdIzvodac
ORDER BY Angazman.PocetniDatum

--3 Ispiši agente i izvođače koji žive na istom poštanskom broju. (10)
SELECT Agent.Ime, Agent.Prezime, Izvodac.Naziv, Agent.Grad
FROM Agent INNER JOIN Izvodac ON Agent.PostanskiBroj = Izvodac.PostanskiBroj

--4	Ispiši podatke o klijentu (ime, prezime), izvođaču kojeg je angažirao, datumu i vremenu 
-- početka i kraja angažmana, duljini angažmana u satima, ugovorenoj cijeni. Rezultate poredaj po 
-- klijentu a zatim po ugovorenoj cijeni silazno. (131)
SELECT Klijent.Ime, Klijent.Prezime, Izvodac.Naziv, Angazman.PocetniDatum, Angazman.ZavrsniDatum,
DATEDIFF(hh, Angazman.PocetniDatum, Angazman.ZavrsniDatum)[Sati], Angazman.UgovorenaCijena
FROM Klijent INNER JOIN Angazman ON Klijent.IdKlijent = Angazman.IdKlijent INNER JOIN Izvodac ON
Angazman.IdIzvodac = Izvodac.IdIzvodac
ORDER BY Klijent.Prezime, Angazman.UgovorenaCijena DESC

/*5 Ispiši podatke o izvođaču (naziv, web, email) i podatke o njegovom angažmanu 
(datum, iznos) i to samo za izvođače kojima je žanr Standards ili Salsa. 
Rezultate poredati po nazivu izvođača a unutar naziva po datumu početka angažmana silazno. 
(50)
*/ 
SELECT Izvodac.Naziv, Izvodac.Web, Izvodac.Email, Angazman.PocetniDatum, Angazman.UgovorenaCijena
FROM Izvodac INNER JOIN Angazman ON Izvodac.IdIzvodac = Angazman.IdIzvodac
INNER JOIN Izvodac_Zanr ON Izvodac.IdIzvodac = Izvodac_Zanr.IdIzvodac
INNER JOIN MuzickiZanr ON Izvodac_Zanr.IdZanr = MuzickiZanr.IdZanr
--WHERE MuzickiZanr.NazivZanra = 'Standards' OR MuzickiZanr.NazivZanra = 'Salsa'
WHERE MuzickiZanr.NazivZanra IN ('Standards', 'Salsa')
ORDER BY Izvodac.Naziv, Angazman.PocetniDatum DESC

--OUTER JOIN
/*
1. Ispiši sve izvođače i njihove angažmane, dakle i one koji nemaju niti jedan angažman.(14)
*/

SELECT Izvodac.Naziv, Angazman.PocetniDatum, Angazman.UgovorenaCijena
FROM Izvodac LEFT OUTER JOIN Angazman ON Izvodac.IdIzvodac = Angazman.IdIzvodac

--b riješi sa RIGHT JOIN
SELECT Izvodac.Naziv, Angazman.PocetniDatum, Angazman.UgovorenaCijena
FROM Angazman RIGHT OUTER JOIN Izvodac ON Izvodac.IdIzvodac = Angazman.IdIzvodac

/*
2
Ispiši izvođače koji nisu imali niti jedan nastup. Riješi kao LEFT i kao RIGHT JOIN. (1)
*/
SELECT Izvodac.Naziv, Angazman.PocetniDatum, Angazman.UgovorenaCijena
FROM Izvodac LEFT OUTER JOIN Angazman ON Izvodac.IdIzvodac = Angazman.IdIzvodac
WHERE Angazman.BrojAngazmana IS NULL