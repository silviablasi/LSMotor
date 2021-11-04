-- OLTP vs OLAP comparison

-- Query simple which involves 1 table:
-- Selecciona els ID dels drivers, l'ID de la cursa i el numero dels drivers que hagin quedat 1ers en alguna cursa

USE F1_OLTP;
SELECT raceId, driverId, number 
FROM qualifying
WHERE position = 1;

USE localolap;
SELECT raceId, driverId, numberQ 
FROM infoResult
WHERE positionR = 1;


-- QUERY COMPLEXA += 5 TAULES
-- Mostra el nom dels drivers ordenats per ordre alfabètic
-- no siguin de nacionalitat española, 
-- que el seu nom continui com a minim una lletra a
-- que no han quedat mai per sota de 10
-- que la nacionalitat del constructor sigui española

USE F1_OLTP;
SELECT d.forename
FROM drivers as d 
JOIN qualifying as q ON d.driverId = q.driverId 
JOIN results as r on r.driverId = d.driverId
JOIN races as race ON race.raceId = r.raceId
JOIN constructors as c ON c.constructorId = r.constructorId
WHERE q.position > 9
	AND d.forename LIKE '%a%'
	AND d.nationality NOT LIKE '%Spanish%'
	AND race.year > 2009
    AND c.nationality LIKE '%Spanish%'
GROUP BY d.forename
ORDER BY d.forename;

USE localolap;
SELECT cd.forenameD
FROM constructorDriver as cd 
JOIN infoResult AS ir ON ir.driverId = cd.driverId
JOIN infoRace AS r ON ir.raceId = r.raceId
WHERE ir.positionQ > 9
	AND cd.forenameD LIKE '%a%'
	AND cd.nationalityD NOT LIKE 'Spanish'
	AND r.yearR > 2009
    AND cd.nationalityC LIKE '%Spanish%'
GROUP BY cd.forenameD
ORDER BY cd.forenameD;


-- Insert
USE F1_OLTP;
INSERT INTO races VALUES(12345, 2010, 4, 12334, 'Montmelo', '2010-10-02', '12:20', 'www.montmelo.com');

USE localolap;
INSERT INTO infoRace VALUES (12345, '789Mont', 'Montmelo', 'Barcelona', 'Spain', 278982.00, 45678.9,  75678, 'www.montmelo.com', 
5432, 'raceURL.com', 2020, 32, 'CursaMontmelo', '2010-10-02', '12:20', 'www.satus.com');


-- Update
USE F1_OLTP;
UPDATE races
SET name = 'UPTATED RACE'
WHERE raceId = 112;

USE localolap;
UPDATE infoRace
SET nameC = 'UPTATED NOM_CIRCUIT RACE 112'
WHERE raceId = 112;


-- Delete
USE F1_OLTP;
DELETE FROM seasons 
WHERE url = 'https://en.wikipedia.org/wiki/1955_Formula_One_season';

USE localolap;
DELETE FROM infoRace
WHERE urlS = 'https://en.wikipedia.org/wiki/1955_Formula_One_season';

