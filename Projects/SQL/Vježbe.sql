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
(50)*/ 
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

/*
3.
Ispiši agente koji nisu obavili niti jedan angažman. (2)
*/

SELECT Agent.Ime, Agent.Prezime
FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
WHERE Angazman.BrojAngazmana IS NULL

--PONAVLJANJE
--1.	Ispiši proizvode kojima cijena nije između 300 i 600 a stanje je veće od 30. Neka se uz svaki proizvod vidi i naziv kategorije. (4)
SELECT Proizvod.*, Kategorija.Opis [Kategorija] FROM Proizvod
INNER JOIN Kategorija ON Proizvod.IdKategorija=Kategorija.Id
WHERE ProdajnaCijena NOT BETWEEN 300 AND 600 AND Stanje>30

--2 Ispiši proizvode kojima je cijena u rasponu od 100-300 ili od 1000-2000. Neka se vide sljedeći podaci: id, naziv, prodajna cijena i naziv kategorije. Poredaj po nazivu. (21)
SELECT Proizvod.*, Kategorija.Opis [Kategorija] 
FROM Proizvod LEFT OUTER JOIN Kategorija ON Proizvod.IdKategorija=Kategorija.Id
WHERE Proizvod.ProdajnaCijena  BETWEEN 100 AND 300 OR Proizvod.ProdajnaCijena BETWEEN 1000 and 2000
ORDER BY Proizvod.Naziv

--3 Ispiši dobavljače koji u adresi imaju pojam ave (3)
SELECT * FROM Dobavljac
WHERE Adresa LIKE '%ave%'

--4 Ispiši dobavljače koji imaju upisan e-mail. (6)
SELECT * FROM Dobavljac
WHERE Email IS NOT NULL

--5 Ispiši klijente koji nemaju narudžbi (2)
SELECT Klijent.Id, Klijent.Ime, Klijent.Prezime
FROM Klijent LEFT OUTER JOIN Narudzba ON Klijent.Id = Narudzba.IdKlijent
WHERE Narudzba.Id IS NULL

--6 Ispiši proizvode koji nisu naručivani (2) Proizvod Narudzba_Detalji
SELECT Proizvod.*
FROM Proizvod LEFT OUTER JOIN Narudzba_Detalji ON Proizvod.id = Narudzba_Detalji.IdProizvod
WHERE Narudzba_Detalji.Id IS NULL

--7. Ispiši narudžbe koje su zaprimljene u 8 ili 12 mjesecu 2011.  Uz podatke o narudžbi neka se vidi ime i prezime klijenta za kojeg je napravljena narudžba. 
--Poredati po datumu silazno. (315)
SELECT Klijent.Ime, Klijent.Prezime, Narudzba.*
FROM Narudzba LEFT OUTER JOIN  Klijent ON Narudzba.IdKlijent = Klijent.Id
WHERE YEAR(Narudzba.DatumNarudzbe) = 2011 AND MONTH(Narudzba.DatumNarudzbe) IN (8,12)
ORDER BY Narudzba.DatumNarudzbe DESC

--Agregatne funkcije
USE agencija
--1.a. - Ispišite broj klijenata. (16)
SELECT COUNT(*) FROM Klijent

--1.b. Ispišite ukupnu vrijednost svih angažmana. (151075)
SELECT SUM(UgovorenaCijena) [Ukupna cijena] FROM Angazman
--1.c. Ispišite datum najranije ugovorenog angažmana.  (29.6.2016)
--MIN pocetniDatum FROM Angazman
SELECT MIN(PocetniDatum) [Najraniji datum] FROM Angazman
--1.d. Ispišite datum najkasnije ugovorenog angažmana (29.12.2016)
--MAX pocetniDatum FROM Angazman

--1.e. Ispišite broj, ukupni iznos i prosječnu cijenu angažmana 
--ugovorenih u 8. i 9. mjesecu 2016
SELECT COUNT(*) Broj, SUM(UgovorenaCijena) [Ukupni iznos], AVG(UgovorenaCijena) [Prosječna cijena]
FROM Angazman WHERE YEAR(PocetniDatum) = 2016 AND MONTH(PocetniDatum) IN (8,9)

--1.f. Ispišite broj i ugovorenu cijenu najranije ugovorenog angažmana.
--izracunam najraniji datum a onda ga ubacim u drugi upit

SELECT MIN(PocetniDatum) FROM Angazman

SELECT BrojAngazmana, UgovorenaCijena FROM Angazman 
WHERE PocetniDatum = '2016-06-01'

--riješi jednim upitom
SELECT BrojAngazmana, UgovorenaCijena FROM Angazman 
WHERE PocetniDatum = (SELECT MIN(PocetniDatum) FROM Angazman)


USE webshop

--a. Ispišite prosječnu cijenu bicikala iz podkategorije 
--Mountain bikes. (1624,99)

/*SELECT * FROM podkategorija
SELECT * FROM Kategorija*/
SELECT AVG(ProdajnaCijena) [Prosječna cijena] FROM Proizvod INNER JOIN Podkategorija 
ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Mountain bikes'

 --b. Ispišite cijenu najskupljeg proizvoda iz 
 -- podkategorije Handlebars. (93,06)
SELECT MAX(ProdajnaCijena) FROM Proizvod INNER JOIN Podkategorija 
ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Handlebars'

--c. Ispišite cijenu i naziv najskupljeg proizvoda u dućanu. (Minipump, 17100)
SELECT ProdajnaCijena, Naziv FROM Proizvod WHERE ProdajnaCijena = 
(SELECT MAX(ProdajnaCijena) FROM Proizvod) -- select unutar selecta





--GROUP BY
/*
SELECT polje1,polje2,AVG,SUM...
FROM tablica1 INNER JOIN tablica2 ... 
WHERE uvjeti
GROUP BY polje1, polje2
-- uvjet na agregatnu funkciju
ORDER BY polje1, alias
*/

USE Agencija
--1.a Ispiši nazive agenata, zbroj svih ugovorenih cijena angažmana i 
--ukupnu proviziju po agentu. Ispisati i agente bez angažmana a NULL 
--vrijednosti pretvoriti u 0. (10)
SELECT Agent.Ime, Agent.Prezime, COALESCE (SUM(Angazman.UgovorenaCijena),0) Ukupno, COALESCE (SUM(Angazman.UgovorenaCijena * Agent.Provizija),0)[Ukupna provizija]
FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
GROUP BY Agent.Ime, Agent.Prezime

--Ispiši agente koji su ugovorili angažmana vrijednosti veće od 10000. 
--Uz ime agenta ispiši i taj iznos. (7)
--!! HAVING !!--
SELECT Agent.Ime, Agent.Prezime, COALESCE (SUM(Angazman.UgovorenaCijena),0) Ukupno
FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
GROUP BY Agent.Ime, Agent.Prezime
HAVING SUM(Angazman.UgovorenaCijena) > 10000
ORDER BY Ukupno

--1f "Koji agenti su ugovorili angažmana u ukupnoj vrijednosti većoj od 3000 u 
-- prosincu 2016?. Ispisati naziv agenta i ukupnu vrijednost. " (4)
SELECT Agent.Ime, Agent.Prezime, COALESCE (SUM(Angazman.UgovorenaCijena),0) Ukupno
FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
WHERE YEAR(Angazman.PocetniDatum) = 2016 AND MONTH(Angazman.PocetniDatum) = 12
GROUP BY Agent.Ime, Agent.Prezime
HAVING SUM(Angazman.UgovorenaCijena) > 3000
ORDER BY Ukupno

USE webshop
--2a Ispiši za svaku godinu u kojoj je dućan radio ukupni iznos narudžbi, minimalni 
--iznos i maksimalni iznos na narudžbi. Poredati po iznosu narudžbi silazno. (3)
SELECT YEAR(Narudzba.DatumNarudzbe) Godina, 
SUM(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) Ukupno,
MIN(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) [Minimalni iznos],
MAX(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) [Maximalni iznos]
FROM Narudzba INNER JOIN NarudzbaDetalj ON Narudzba.idNarudzba = NarudzbaDetalj.idNarudzba
GROUP BY YEAR(Narudzba.DatumNarudzbe)
ORDER BY Ukupno DESC

/*2b Ispiši klijente (id, ime, prezime) i uz svakog ukupni iznos narudžbi koje je 
naručio te broj njegovih narudžbi. Pritom treba prikazati samo klijente čiji je 
ukupni iznos barem 20% veći od prosječnog iznosa narudžbe. (3237) */
SELECT Klijent.idKlijent, Osoba.ime, Osoba.Prezime, 
SUM(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) Ukupno,
COUNT(*) [Broj narudžbi]
FROM Klijent INNER JOIN Osoba ON Klijent.idOsoba = Osoba.idOsoba INNER JOIN Narudzba
ON Klijent.idKlijent = Narudzba.idKlijent INNER JOIN NarudzbaDetalj ON Narudzba.idNarudzba =
NarudzbaDetalj.idNarudzba
GROUP BY Klijent.idKlijent, Osoba.ime, Osoba.Prezime
HAVING SUM(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) >
(SELECT SUM(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) FROM NarudzbaDetalj)/
(SELECT COUNT(*) FROM Narudzba)*1.2

--prosjecni iznos narudžbi
--zbroj svih iznosa / broj narudžbi
--zbroj svih iznosa
SELECT SUM(NarudzbaDetalj.Kolicina * NarudzbaDetalj.JedinicnaCijena) FROM NarudzbaDetalj
--broj narudzbi
SELECT COUNT(*) FROM Narudzba



--podupit ili subquery - SELECT unutar SELECTa
--Tablični i skalarni
--Tablični - vraćaju zapise, nalaze se u WHERE dijelu vanjskog upita 
--Skalarni - vraćaju broj, nalaze se u SELECT dijelu vanjskog upita
--Tablični upiti - dvije vrste - IN 1 EXISTS

--1a. Ispiši proizvode iz podkategorija koje u nazivu sadrže riječi Bike (105)
-- IN
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
WHERE idPodKategorija IN (SELECT idPodKategorija FROM Podkategorija 
WHERE Naziv LIKE '%Bike%')

--isto rješenje sa EXISTS
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
WHERE EXISTS (SELECT idPodKategorija FROM Podkategorija 
WHERE Naziv LIKE '%Bike%' AND Podkategorija.idPodkategorija = Proizvod.idPodKategorija)

--Kako bismo riješili sa običnim join
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
INNER JOIN Podkategorija ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv LIKE '%Bike%'

--1b. Ispiši narudžbe proizvoda iz podkategorije Wheels (720). 
SELECT * FROM Narudzba WHERE idNarudzba IN 
(SELECT NarudzbaDetalj.idNarudzba FROM NarudzbaDetalj INNER JOIN Proizvod ON
NarudzbaDetalj.idProizvod = Proizvod.idProizvod INNER JOIN Podkategorija ON
Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Wheels')

--sa exists
SELECT * FROM Narudzba WHERE EXISTS
(	SELECT NarudzbaDetalj.idNarudzba FROM NarudzbaDetalj INNER JOIN Proizvod ON
NarudzbaDetalj.idProizvod = Proizvod.idProizvod INNER JOIN Podkategorija ON
Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Wheels' AND NarudzbaDetalj.idNarudzba = Narudzba.idNarudzba
)

--Skalarni podupit
-- Podupit u SELECT listi
-- SELECT polje, (SELECT ... podupit) FROM tablice
-- a.	"Ispiši proizvode i broj njihovih narudžbi".  
--Zadatak se može riješiti kao GROUP BY pa prvo riješite kao tako 
--a onda kao skalarni upit. Usporedite broj zapisa. (509)
SELECT idProizvod, Naziv, ProdajnaCijena,
(SELECT COUNT(*) FROM NarudzbaDetalj WHERE NarudzbaDetalj.idProizvod = Proizvod.idProizvod) [Broj narudžbi]
FROM Proizvod ORDER BY [Broj narudžbi] DESC