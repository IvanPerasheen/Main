--Agregatne funkcije

SELECT * FROM Klijent
--COUNT 
SELECT COUNT(*) FROM Klijent
--COUNT(polje)
SELECT COUNT(ime) [Broj zapisa] FROM Klijent

--SUM 
SELECT SUM(ProdajnaCijena) FROM Proizvod
--AVG 
SELECT AVG(ProdajnaCijena) FROM Proizvod
--MIN
SELECT MIN(ProdajnaCijena) FROM Proizvod
--varchar polje
SELECT MIN(Prezime) FROM Klijent
-- datum polje
SELECT MIN(DatumNarudzbe) FROM Narudzba

