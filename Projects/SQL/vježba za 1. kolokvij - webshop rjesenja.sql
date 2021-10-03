USE webshop
--1
SELECT * FROM Osoba
 WHERE Osoba.Prezime LIKE 'B%' AND Osoba.Ime LIKE '%N' AND Titula IS NOT NULL

 --2
 SELECT Narudzba.DatumNarudzbe, 
 Osoba.Ime + ' ' +  Osoba.Prezime Klijent, DATEDIFF(dd,Narudzba.DatumNarudzbe, Narudzba.DatumSlanja) [VrijemePripreme]
 FROM Narudzba INNER JOIN Klijent ON Narudzba.idKlijent = Klijent.idKlijent INNER JOIN Osoba ON Klijent.idOsoba = Osoba.idOsoba
WHERE DATEDIFF(dd,Narudzba.DatumNarudzbe, Narudzba.DatumSlanja) < 7
ORDER BY DatumNarudzbe

 --3
SELECT Osoba.* FROM Osoba LEFT OUTER JOIN Telefon ON Osoba.idOsoba = Telefon.idOsoba WHERE Osoba.Prezime LIKE 'P%' AND Telefon.id IS NULL
--4
SELECT * FROM Proizvod WHERE ProdajnaCijena = (SELECT MIN(ProdajnaCijena) FROM Proizvod)

--5
SELECT * FROM Proizvod WHERE idProizvod IN (SELECT narudzbadetalj.idProizvod FROM Narudzbadetalj
INNER JOIN Narudzba ON Narudzbadetalj.idnarudzba = Narudzba.idNarudzba WHERE DatumNarudzbe BETWEEN '2015-08-01' AND '2015-09-30')

SELECT * FROM Proizvod WHERE EXISTS (SELECT narudzbadetalj.idProizvod FROM Narudzbadetalj
INNER JOIN Narudzba ON Narudzbadetalj.idnarudzba = Narudzba.idNarudzba WHERE DatumNarudzbe BETWEEN '2015-08-01' AND '2015-09-30'
AND NarudzbaDetalj.idProizvod = Proizvod.idProizvod)

--6
SELECT        Proizvod.idProizvod, Proizvod.Naziv, COUNT(*) AS broj, 
SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) AS Ukupno
FROM            NarudzbaDetalj INNER JOIN
                         Proizvod ON NarudzbaDetalj.IdProizvod = Proizvod.idProizvod
GROUP BY Proizvod.idProizvod, Proizvod.Naziv
HAVING SUM(NarudzbaDetalj.JedinicnaCijena * NarudzbaDetalj.Kolicina) BETWEEN 10000 AND 20000
ORDER BY Ukupno DESC



--7
SELECT Podkategorija.idPodkategorija, PodKategorija.Naziv, 
(SELECT COUNT(*) FROM Proizvod WHERE IdPodKategorija = PodKategorija.idPodkategorija) AS [Broj proizvoda],
(SELECT AVG(ProdajnaCijena) FROM Proizvod WHERE IdPodKategorija = PodKategorija.idPodkategorija) AS [Prosjeèna cijena]
 FROM PodKategorija

 