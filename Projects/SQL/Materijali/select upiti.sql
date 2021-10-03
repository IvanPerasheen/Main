USE narudzbe

--ponavljanje SELECT
--=
SELECT ime, prezime
FROM Klijent
WHERE prezime = 'Davolio'

--LIKE - počinje
SELECT ime, prezime
FROM Klijent
WHERE prezime LIKE 'D%'

--LIKE - završava sa s
SELECT ime, prezime
FROM Klijent
WHERE prezime LIKE '%s'
--LIKE - sadrži
SELECT ime, prezime
FROM Klijent
WHERE prezime LIKE '%s%'

--BETWEEN
SELECT * FROM Narudzba
WHERE DatumNarudzbe BETWEEN '2010-01-01' AND '2020-03-25'
--bez between
SELECT * FROM Narudzba
WHERE DatumNarudzbe >= '2010-01-01' AND DatumNarudzbe <= '2020-03-25'

--Izrazi
--spajanje polja operator + (koristimo alias)
SELECT ime + ' ' + prezime AS [puno ime]
FROM Klijent
--Neko polje je NULL
--Koristimo funkciju COALESCE
SELECT COALESCE(ime,'') + ' ' + COALESCE(prezime, '') [Puno ime]
FROM Klijent

--2
--Možemo poredati po aliasu
SELECT idProizvod, JedCijena, Kolicina, JedCijena * Kolicina [Ukupno]
FROM Narudzba_Detalji
ORDER BY [Ukupno] DESC 

--3
SELECT * FROM Narudzba
--razlika u danima između datuma
--verzija 1 - oduzimanje
SELECT *, DatumSlanja - DatumNarudzbe [Vrijeme pripreme] FROM Narudzba
--verzija 2 - koristimo funkciju za pretvorbu tipa - CONVERT ili CAST
SELECT *, CONVERT(int, DatumSlanja - DatumNarudzbe) [Vrijeme pripreme] FROM Narudzba
--bolja funkcija za razlika datuma - DATEDIFF
SELECT *, DATEDIFF(dd, DatumNarudzbe, DatumSlanja) [Vrijeme pripreme] FROM Narudzba
ORDER BY [Vrijeme pripreme] DESC

