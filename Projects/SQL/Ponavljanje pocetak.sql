USE agencija
--1 Ispiši klijente kojima poštanski broj završava na 006
SELECT * FROM Klijent 
WHERE PostanskiBroj LIKE '%006'

--2 Ispiši agente koji žive u Redmondu i rade za proviziju veću od 0,2 (1)
SELECT * FROM Agent
WHERE Grad = 'Redmond' AND Provizija > 0.2

--3 Ispiši angažmane koji su bili ugovoreni u 7. mjesecu 2016 i kojima je ugovorena cijena bila veća od 2000
SELECT * FROM Angazman WHERE MONTH(PocetniDatum) = 7 AND YEAR(PocetniDatum) = 2016 AND UgovorenaCijena > 2000

--4	Ispiši angažmane i uz svakog razliku u danima između početka i kraja (131) DATEDIFF(dd, pocetni, krajnji)
SELECT *, DATEDIFF(DD, PocetniDatum, ZavrsniDatum) [Razlika u danima] FROM Angazman

--JOINOVI
/*1 Ispiši podatke o agentu (ime, prezime) i datum početka i završetka angažmana koji je organizirao.
Rezultate poredaj po datumu početka angažmana. (131)*/
SELECT Agent.Ime, Agent.Prezime, Angazman.PocetniDatum, Angazman.ZavrsniDatum 
FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
ORDER BY PocetniDatum

 --2 Proširi upit iz točke a tako da se ispisuje i naziv izvođača koji je bio angažiran. (131)
SELECT Agent.Ime, Agent.Prezime, Angazman.PocetniDatum, Angazman.ZavrsniDatum, Izvodac.Naziv
FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent INNER JOIN Izvodac ON Angazman.IdIzvodac = Izvodac.IdIzvodac
ORDER BY PocetniDatum

--3 Ispiši agente i izvođače koji žive na istom poštanskom broju. (10)
SELECT Agent.Ime, Agent.Prezime, Izvodac.Naziv 
FROM Agent INNER JOIN Izvodac ON Agent.PostanskiBroj = Izvodac.PostanskIBroj

/*4	Ispiši podatke o klijentu (ime, prezime), izvođaču kojeg je angažirao, datumu i vremenu 
 početka i kraja angažmana, duljini angažmana u satima, ugovorenoj cijeni. Rezultate poredaj po 
 klijentu a zatim po ugovorenoj cijeni silazno. (131)*/
 SELECT Klijent.Ime, Klijent.Prezime, Izvodac.Naziv, Angazman.PocetniDatum,Angazman.ZavrsniDatum, 
 DATEDIFF(hh,Angazman.PocetniDatum,Angazman.ZavrsniDatum) [Sati], Angazman.UgovorenaCijena 
 FROM Klijent INNER JOIN Angazman ON Klijent.IdKlijent = Angazman.IdKlijent INNER JOIN Izvodac ON Angazman.IdIzvodac = Izvodac.IdIzvodac
 ORDER BY Klijent.Prezime, Angazman.UgovorenaCijena DESC

 /*5 Ispiši podatke o izvođaču (naziv, web, email) i podatke o njegovom angažmanu 
(datum, iznos) i to samo za izvođače kojima je žanr Standards ili Salsa. 
Rezultate poredati po nazivu izvođača a unutar naziva po datumu početka angažmana silazno. 
(50)*/ 
SELECT Izvodac.Naziv, Izvodac.Web, Izvodac.Email, Angazman.PocetniDatum, Angazman.UgovorenaCijena 
FROM Angazman INNER JOIN Izvodac ON Angazman.IdIzvodac = Izvodac.IdIzvodac 
INNER JOIN Izvodac_Zanr ON Izvodac.IdIzvodac = Izvodac_Zanr.IdIzvodac
INNER JOIN MuzickiZanr ON Izvodac_Zanr.IdZanr = MuzickiZanr.IdZanr
WHERE MuzickiZanr.NazivZanra IN ('Standards','Salsa')
ORDER BY Izvodac.Naziv, Angazman.PocetniDatum DESC

--OUTER JOIN
--1 Ispiši sve izvođače i njihove angažmane, dakle i one koji nemaju niti jedan angažman.(14)
SELECT Izvodac.Naziv, Angazman.* 
FROM Izvodac LEFT OUTER JOIN Angazman ON Izvodac.IdIzvodac = Angazman.IdIzvodac

--b riješi sa RIGHT JOIN
SELECT Izvodac.Naziv, Angazman.* 
FROM Angazman RIGHT OUTER JOIN Izvodac ON Izvodac.IdIzvodac = Angazman.IdIzvodac


--2 Ispiši izvođače koji nisu imali niti jedan nastup. Riješi kao LEFT i kao RIGHT JOIN. (1)
SELECT Izvodac.Naziv, Angazman.* 
FROM Izvodac LEFT OUTER JOIN Angazman ON Izvodac.IdIzvodac = Angazman.IdIzvodac
WHERE Angazman.BrojAngazmana IS NULL

--3 Ispiši agente koji nisu obavili niti jedan angažman. (2)
SELECT Agent.Ime, Agent.Prezime FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
WHERE Angazman.IdAgent IS NULL

--Agregatne funkcije
USE agencija
--1.a. Ispišite broj klijenata. (16)
SELECT COUNT(*) FROM Klijent

--1.b. Ispišite ukupnu vrijednost svih angažmana. (151075)
SELECT SUM(Angazman.UgovorenaCijena) [Suma cijena] FROM Angazman

--1.c. Ispišite datum najranije ugovorenog angažmana.  (29.6.2016)
SELECT MIN(Angazman.PocetniDatum) [Najraniji datum] FROM Angazman

--1.e.	Ispišite broj, ukupni iznos i prosječnu cijenu angažmana ugovorenih u 8. i 9. mjesecu 2016
SELECT COUNT(BrojAngazmana) [Broj], SUM(UgovorenaCijena), AVG(UgovorenaCijena) FROM Angazman
WHERE MONTH(PocetniDatum) IN (8,9)

--1.f.	Ispišite broj i ugovorenu cijenu najranije ugovorenog angažmana.
SELECT Angazman.BrojAngazmana, Angazman.UgovorenaCijena FROM Angazman
WHERE PocetniDatum = (SELECT MIN(PocetniDatum) FROM Angazman)


USE webshop
--a. Ispišite prosječnu cijenu bicikala iz podkategorije Mountain bikes. (1624,99)
SELECT AVG(ProdajnaCijena) [Prosjecna cijena podkategorije Mountain bikes] FROM Proizvod INNER JOIN Podkategorija 
ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija 
WHERE Podkategorija.Naziv = 'Mountain bikes'

--b. Ispišite cijenu najskupljeg proizvoda iz podkategorije Handlebars. (93,06)
SELECT MAX(ProdajnaCijena) [Najskuplji] FROM Proizvod INNER JOIN Podkategorija 
ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija 
WHERE Podkategorija.Naziv = 'Handlebars'

--c. Ispišite cijenu i naziv najskupljeg proizvoda u dućanu. (Minipump, 17100)
SELECT Proizvod.Naziv, ProdajnaCijena FROM Proizvod INNER JOIN Podkategorija 
ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija 
WHERE ProdajnaCijena = (SELECT MAX(ProdajnaCijena) FROM Proizvod)


use agencija
--GROUP BY
/*1.a.	Ispiši nazive agenata, zbroj svih ugovorenih cijena angažmana i ukupnu proviziju po agentu. Ispisati i agente bez angažmana a NULL vrijednosti pretvoriti u 0. (10)*/
SELECT Agent.Ime, Agent.Prezime, COALESCE(SUM(Angazman.UgovorenaCijena), 0) [Sum cijena], COALESCE(SUM(Agent.Provizija * Angazman.UgovorenaCijena), 0)  [Sum provizija] 
FROM Agent LEFT OUTER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
GROUP BY Agent.Ime, Agent.Prezime

--1.b.	Ispiši agente koji su ugovorili angažmana vrijednosti veće od 10000. Uz ime agenta ispiši i taj iznos. (7)
SELECT Agent.Ime,Agent.Prezime, COALESCE(SUM(Angazman.UgovorenaCijena),0) Ukupno FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
GROUP BY Agent.Ime, Agent.Prezime
HAVING SUM(Angazman.UgovorenaCijena) > 10000
ORDER BY Ukupno

--1.d.	Ispiši za svaki žanr broj klijenata koji ga preferiraju. Za žanrove koje nitko ne preferira ispisati 0. (26)
SELECT MuzickiZanr.NazivZanra, COALESCE(COUNT(Klijent_Preference.IdZanr),0) Preferira FROM MuzickiZanr LEFT OUTER JOIN Klijent_Preference ON MuzickiZanr.IdZanr = Klijent_Preference.IdZanr
GROUP BY MuzickiZanr.NazivZanra
ORDER BY Preferira

--1.f. Koji agenti su ugovorili angažmana u ukupnoj vrijednosti većoj od 3000 u prosincu 2016?. Ispisati naziv agenta i ukupnu vrijednost. (4)
SELECT Agent.Ime, Agent.Prezime, COALESCE(SUM(Angazman.UgovorenaCijena),0) Ukupno FROM Agent INNER JOIN Angazman ON Agent.IdAgent = Angazman.IdAgent
WHERE YEAR(Angazman.PocetniDatum) = 2016 AND MONTH(Angazman.PocetniDatum) = 12
GROUP BY Agent.Ime, Agent.Prezime
HAVING SUM(Angazman.UgovorenaCijena) > 3000
ORDER BY Ukupno

USE webshop
--2.a. Ispiši za svaku godinu u kojoj je dućan radio ukupni iznos narudžbi, minimalni iznos i maksimalni iznos na narudžbi. Poredati po iznosu narudžbi silazno. (3)
SELECT YEAR(Narudzba.DatumNarudzbe) Godina, 
SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) Ukupno, 
MIN(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) MinimalanIznos, 
MAX(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) MaximalanIznos FROM Narudzba INNER JOIN NarudzbaDetalj ON 
Narudzba.idNarudzba = NarudzbaDetalj.idNarudzba
GROUP BY YEAR(Narudzba.DatumNarudzbe)
ORDER BY Ukupno DESC

/*2.b. Ispiši klijente (id, ime, prezime) i uz svakog ukupni iznos narudžbi koje je 
naručio te broj njegovih narudžbi. Pritom treba prikazati samo klijente čiji je 
ukupni iznos barem 20% veći od prosječnog iznosa narudžbe. (3237) */
SELECT Klijent.idKlijent, Osoba.Ime, Osoba.Prezime, 
SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) Iznos, 
COUNT(*) BrojNarudzbi 
FROM Osoba INNER JOIN Klijent ON Osoba.idOsoba = Klijent.idOsoba 
INNER JOIN Narudzba ON Klijent.idKlijent = Narudzba.idKlijent 
INNER JOIN NarudzbaDetalj ON Narudzba.idNarudzba = NarudzbaDetalj.idNarudzba
GROUP BY Klijent.idKlijent, Osoba.Ime, Osoba.Prezime
HAVING SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) > 
(SELECT SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) FROM NarudzbaDetalj) / 
(SELECT COUNT(*) FROM Narudzba) * 1.2
ORDER BY Iznos DESC

--podupit ili subquery - SELECT unutar SELECTa
--Tablični i skalarni
--Tablični - vraćaju zapise, nalaze se u WHERE dijelu vanjskog upita 
--Skalarni - vraćaju broj, nalaze se u SELECT dijelu vanjskog upita
--Tablični upiti - dvije vrste - IN 1 EXISTS

--1.a. Ispiši proizvode iz podkategorija koje u nazivu sadrže riječi Bike (105)
-- IN
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
WHERE idPodKategorija IN (SELECT idPodKategorija FROM Podkategorija WHERE Naziv LIKE '%Bike%')

--EXISTS
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
WHERE EXISTS (SELECT idPodKategorija FROM Podkategorija 
WHERE Naziv LIKE '%Bike%' AND Proizvod.idPodKategorija = Podkategorija.idPodkategorija)

--1.b. Ispiši narudžbe proizvoda iz podkategorije Wheels (720). 
--IN 
SELECT * FROM Narudzba 
WHERE idNarudzba IN (SELECT NarudzbaDetalj.idNarudzba FROM NarudzbaDetalj 
INNER JOIN Proizvod ON NarudzbaDetalj.idProizvod = Proizvod.idProizvod
INNER JOIN Podkategorija ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Wheels')

--EXISTS
SELECT * FROM Narudzba 
WHERE EXISTS (SELECT NarudzbaDetalj.idNarudzba FROM NarudzbaDetalj 
INNER JOIN Proizvod ON NarudzbaDetalj.idProizvod = Proizvod.idProizvod
INNER JOIN Podkategorija ON Proizvod.idPodKategorija = Podkategorija.idPodkategorija
WHERE Podkategorija.Naziv = 'Wheels' AND Narudzba.idNarudzba = NarudzbaDetalj.idNarudzba)



/*Skalarni podupit
Podupit u SELECT listi
                                                               SELECT polje, (SELECT ... podupit) FROM tablice
1.a.	"Ispiši proizvode i broj njihovih narudžbi".  
Zadatak se može riješiti kao GROUP BY pa prvo riješite kao tako 
a onda kao skalarni upit. Usporedite broj zapisa. (509)*/
SELECT idProizvod, Naziv, ProdajnaCijena,
(SELECT COUNT(*) FROM NarudzbaDetalj WHERE Proizvod.idProizvod = NarudzbaDetalj.idProizvod) [Broj narudzbi]
FROM Proizvod ORDER BY [Broj narudzbi] DESC




