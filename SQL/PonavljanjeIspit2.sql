--1. Ispiši narudžbe klijenata čije prezime počinje sa B i koji su radili narudžbe u 10 i 12. mjesecu 2011. Prikaži DatumNarudzbe, DatumSlanja, ime i prezime klijenta. Poredaj po datumu uzlazno.	(39)
SELECT Narudzba.DatumNarudzbe, Narudzba.DatumSlanja, Klijent.Ime, Klijent.Prezime 
FROM Narudzba INNER JOIN Klijent ON Narudzba.IdKlijent = Klijent.Id
WHERE Klijent.Prezime LIKE 'B%' AND MONTH(Narudzba.DatumNarudzbe) IN (10,12)
ORDER BY Narudzba.DatumNarudzbe DESC

--2. Ispiši stavke narudžbi kod kojih je vrijeme pripreme bilo 2 dana i količina proizvoda na stavki veća od 3. Prikazati datum narudžbe, ime i prezime klijenta, naziv proizvoda, prodajnu cijenu i vrijeme pripreme. Poredati po datumu narudžbe. Vrijeme pripreme je razlika između datuma slanja i datuma narudžbe izraženo u danima. 	(393)
SELECT Narudzba.DatumNarudzbe, Klijent.Ime, Klijent.Prezime, Proizvod.Naziv, Proizvod.ProdajnaCijena, 
DATEDIFF(DD,Narudzba.DatumNarudzbe,Narudzba.DatumSlanja) [Vrijeme pripreme] 
FROM Klijent INNER JOIN Narudzba ON Klijent.Id = Narudzba.IdKlijent
INNER JOIN Narudzba_Detalji ON Narudzba.Id = Narudzba_Detalji.IdNarudzba 
INNER JOIN Proizvod ON Narudzba_Detalji.IdProizvod = Proizvod.Id
WHERE DATEDIFF(DD,Narudzba.DatumNarudzbe,Narudzba.DatumSlanja) = 2 AND Kolicina > 3
ORDER BY DatumNarudzbe

--3. Prikaži kategorije u koje ne spada niti jedan proizvod	(2)
SELECT * FROM Kategorija LEFT OUTER JOIN Proizvod ON Kategorija.Id = Proizvod.IdKategorija
WHERE Proizvod.Id IS NULL

--4. Prikaži podatke o najskupljem proizvodu. Neka se vide id, naziv i prodajna cijena. 	(1)
SELECT Proizvod.Id, Proizvod.Naziv, Proizvod.ProdajnaCijena FROM Proizvod
WHERE ProdajnaCijena = (SELECT MAX(ProdajnaCijena) FROM Proizvod)

--5. Prikaži proizvode i uz svakog ukupni iznos narudžbi, broj narudžbi i najveći i najmanji iznos na narudžbi. Neka se vide samo proizvodi kod kojih je ukupni iznos narudžbe između 10000 i 20000. 	(10)
SELECT Proizvod.Id, Proizvod.Naziv, 
SUM(Narudzba_Detalji.JedCijena * Narudzba_Detalji.Kolicina) Iznos, COUNT(*) Broj, 
MAX(Narudzba_Detalji.JedCijena) Maksimalna, 
MIN(Narudzba_Detalji.JedCijena) Minimalna
FROM Proizvod INNER JOIN Narudzba_Detalji ON Proizvod.Id = Narudzba_Detalji.IdProizvod
GROUP BY Proizvod.Id, Proizvod.Naziv
HAVING SUM(Narudzba_Detalji.JedCijena * Narudzba_Detalji.Kolicina) BETWEEN 10000 AND 20000

--6. Ispiši kategorije proizvoda koji su naručivani u 8. i 9. Mjesecu 2011. Zadatak riješiti upotrebom: IN i EXISTS (40)
SELECT * FROM Proizvod
WHERE IdKategorija IN(SELECT IdKategorija FROM Kategorija INNER JOIN Proizvod ON Kategorija.Id=Proizvod.IdKategorija INNER JOIN Narudzba_Detalji ON Proizvod.Id=Narudzba_Detalji.IdProizvod INNER JOIN Narudzba ON Narudzba_Detalji.IdNarudzba=Narudzba.Id
WHERE YEAR(Narudzba.DatumNarudzbe)=2011 AND MONTH(Narudzba.DatumNarudzbe) IN (8,9))

SELECT * FROM Proizvod
WHERE EXISTS (SELECT IdKategorija FROM Kategorija INNER JOIN Proizvod ON Kategorija.Id=Proizvod.IdKategorija INNER JOIN Narudzba_Detalji ON Proizvod.Id=Narudzba_Detalji.IdProizvod INNER JOIN Narudzba ON Narudzba_Detalji.IdNarudzba=Narudzba.Id
WHERE YEAR(Narudzba.DatumNarudzbe) = 2011 AND MONTH(Narudzba.DatumNarudzbe) IN (8,9) AND Proizvod.IdKategorija = Kategorija.Id)

--7. Prikaži kategorije i uz svaku broj proizvoda i prosječnu cijenu za kategoriju. Trebaju se vidjeti i kategorije koje nemaju niti jedan proizvod. Zadatak riješi koristeći skalarne podupite.	 (8)
SELECT Kategorija.*,
(SELECT COUNT(*) FROM Proizvod WHERE Proizvod.IdKategorija = Kategorija.Id) BrojProizvoda,
(SELECT COALESCE(AVG(Proizvod.ProdajnaCijena),0) FROM Proizvod WHERE Proizvod.IdKategorija = Kategorija.Id) ProsjecnaCijena
FROM Kategorija

--8. Prikaži za svakog klijenta ime, prezime i ukupni iznos narudžbi. Pritom treba prikazati samo klijente kod kojih je ukupni iznos veći od prosječnog iznosa narudžbe po klijentu.	(17)
SELECT Klijent.Ime, Klijent.Prezime, SUM(Narudzba_Detalji.JedCijena*Narudzba_Detalji.Kolicina) UkupniIznos FROM Klijent INNER JOIN Narudzba ON Klijent.Id = Narudzba.IdKlijent INNER JOIN Narudzba_Detalji ON Narudzba.Id = Narudzba_Detalji.IdNarudzba
GROUP BY Klijent.Ime, Klijent.Prezime
HAVING SUM(Narudzba_Detalji.JedCijena*Narudzba_Detalji.Kolicina) > (SUM(Narudzba_Detalji.JedCijena*Narudzba_Detalji.Kolicina)) / (COUNT(*))
ORDER BY UkupniIznos DESC

SELECT Klijent.Ime,Klijent.Prezime,SUM(Kolicina*JedCijena) Ukupno,SUM(Kolicina*JedCijena)/COUNT(Narudzba_Detalji.Id) Prosjek
FROM Klijent INNER JOIN Narudzba ON Klijent.Id=Narudzba.IdKlijent INNER JOIN Narudzba_Detalji ON Narudzba.Id=Narudzba_Detalji.IdNarudzba
GROUP BY Klijent.Ime,Klijent.Prezime
HAVING SUM(Kolicina*JedCijena) > (SUM(Kolicina*JedCijena)/COUNT(*))
ORDER BY Ukupno DESC

