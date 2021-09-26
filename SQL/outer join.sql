USE fakultet

SELECT Osoba.Ime, Osoba.prezime, Mjesto.postanskibroj, Mjesto.Naziv
FROM Osoba INNER JOIN Mjesto ON Osoba.idMjesto = Mjesto.id 

--interesira nas koje osobe nemaju upisano mjesto
SELECT * FROM osoba WHERE Osoba.idMjesto IS NULL

--OUTER JOIN
	--left, right i full OUTER JOIN

--koji gradovi nisu dodijeljeni niti jednoj osobi


--LEFT OUTER JOIN - vrati sve osobe bez obzira imaju li sve upisano mjesto
SELECT Osoba.Ime, Osoba.prezime, Mjesto.Id, Mjesto.postanskibroj, Mjesto.Naziv
FROM Osoba LEFT OUTER JOIN Mjesto ON Osoba.idMjesto = Mjesto.id 

--RIGHT OUTER JOIN - vrati sve zapise iz tablice s desne strane
SELECT Osoba.id, Osoba.Ime, Osoba.prezime, Mjesto.Id, Mjesto.postanskibroj, Mjesto.Naziv
FROM Osoba RIGHT OUTER JOIN Mjesto ON Osoba.idMjesto = Mjesto.id
WHERE Osoba.id IS NULL

--sažeti ispit samo mjesta - OVAKO NESTO NA TESTU
SELECT Mjesto.Id, Mjesto.postanskibroj, Mjesto.Naziv
FROM Osoba RIGHT OUTER JOIN Mjesto ON Osoba.idMjesto = Mjesto.id
WHERE Osoba.id IS NULL

--FULL outer join
SELECT Osoba.id, Osoba.Ime, Osoba.prezime, Mjesto.Id, Mjesto.postanskibroj, Mjesto.Naziv
FROM Osoba FULL OUTER JOIN Mjesto ON Osoba.idMjesto = Mjesto.id
