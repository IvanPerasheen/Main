--1. Ispiši osobe čije prezime počinje sa B, ime završava sa N i imaju upisanu titulu.	(17)
SELECT * FROM Osoba
WHERE Osoba.Prezime LIKE 'B%' AND Osoba.Ime LIKE '%N' AND Titula IS NOT NULL

--2. Ispiši narudžbe kod kojih je vrijeme pripreme bilo manje od 7 dana. Prikazati datum narudžbe, ime i prezime klijenta kao jedan stupac i samo vrijeme pripreme. Poredati po datumu narudžbe. Vrijeme pripreme je razlika između datuma slanja i datuma narudžbe izraženo u danima. 	(53)
SELECT Narudzba.DatumNarudzbe, Osoba.Ime + ' ' + Osoba.Prezime [Klijent], DATEDIFF(dd, Narudzba.DatumNarudzbe, Narudzba.DatumSlanja)  
FROM Narudzba INNER JOIN Klijent ON Narudzba.idKlijent = Klijent.idKlijent INNER JOIN Osoba ON Klijent.idOsoba = Osoba.idOsoba
WHERE DATEDIFF(dd, Narudzba.DatumNarudzbe, Narudzba.DatumSlanja) < 7

--3. Prikaži osobe čije prezime počinje sa P koje nemaju upisan telefon.	(1192)
SELECT * FROM Osoba LEFT OUTER JOIN Telefon ON Osoba.idOsoba = Telefon.idOsoba
WHERE Osoba.Prezime LIKE 'P%' AND Telefon.id IS NULL

--4. Prikaži proizvode sa najmanjom cijenom. Neka se vide id, naziv i prodajna cijena. 	(198)
SELECT Proizvod.idProizvod, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod 
WHERE Proizvod.ProdajnaCijena = (SELECT MIN(Proizvod.ProdajnaCijena) FROM Proizvod)

--5. Ispiši proizvode koji su naručivani u 8. i 9. Mjesecu 2015. Zadatak riješiti upotrebom: a) Upotrebom podupita IN b) Upotrebom podupita EXISTS 	(200)
SELECT * FROM Proizvod WHERE Proizvod.idProizvod IN (SELECT NarudzbaDetalj.idProizvod FROM NarudzbaDetalj INNER JOIN Narudzba ON NarudzbaDetalj.idNarudzba = Narudzba.idNarudzba WHERE MONTH(DatumNarudzbe) IN (8,9) AND YEAR(DatumNarudzbe) = 2015)

SELECT * FROM Proizvod WHERE EXISTS (SELECT NarudzbaDetalj.idProizvod FROM NarudzbaDetalj INNER JOIN Narudzba ON NarudzbaDetalj.idNarudzba = Narudzba.idNarudzba WHERE MONTH(DatumNarudzbe) IN (8,9) AND YEAR(DatumNarudzbe) = 2015 AND Proizvod.idProizvod = NarudzbaDetalj.idProizvod)

--6. Prikaži proizvode i uz svakog ukupni iznos narudžbi  i broj narudžbi. Neka se vide samo proizvodi kod kojih je ukupni iznos narudžbe između 10000 i 20000. 	(26)
SELECT Proizvod.idProizvod, Proizvod.Naziv, COUNT(*) Broj, SUM(NarudzbaDetalj.JedinicnaCijena*NarudzbaDetalj.Kolicina) 
FROM Proizvod INNER JOIN NarudzbaDetalj ON Proizvod.idProizvod = NarudzbaDetalj.idProizvod 
GROUP BY Proizvod.idProizvod, Proizvod.Naziv
HAVING SUM(NarudzbaDetalj.JedinicnaCijena*NarudzbaDetalj.Kolicina) BETWEEN 10000 AND 20000

--7. Prikaži podkategorije i uz svaku broj proizvoda i prosječnu cijenu proizvoda iz te podkategorije. Zadatak riješi koristeći skalarne podupite.	(37)
SELECT Podkategorija.idPodkategorija, Podkategorija.Naziv,
(SELECT COUNT(*) FROM Proizvod WHERE Podkategorija.idPodkategorija = Proizvod.idPodKategorija) broj,
(SELECT AVG(Proizvod.ProdajnaCijena) FROM Proizvod WHERE Podkategorija.idPodkategorija = Proizvod.idPodKategorija) ukupno
FROM Podkategorija
