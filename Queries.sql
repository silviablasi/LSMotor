-- Find the statuses that never happened in the F1 history. Do this with- out using subqueries.
USE localOlap;
SELECT DISTINCT statusIdR, status FROM infoResult 
WHERE resultId IS NULL AND raceId IS NULL;


-- Find the nationality and average time of those drivers whose teams have the lowest average pit stop time.
USE localOlap;
SELECT c2.nationalityD AS nacionalitat, AVG(l2.millisecondsL) AS mitjanaTemps FROM constructorDriver AS c2 
JOIN infoLaps AS l2 ON l2.driverId = c2.driverId AND 
c2.constructorId = 
(SELECT c.constructorId FROM localOlap.infoLaps AS l 
	JOIN localOlap.constructorDriver AS c ON l.driverId = c.driverId
	GROUP BY c.constructorId
    ORDER BY AVG(l.millisecondsP) ASC
    LIMIT 1)
GROUP BY c2.driverId, c2.nationalityD;


-- Search for the drivers (complete name) who have beaten his own qualifying time for each successive round, that is, improving his time in each qualifying round, 
-- and that his fastest lap time on the race was faster than any of the qualifying time of any other driver for that race. Also, check that this achievement landed him in the 
-- podium after the race (any of the top three positions)
USE F1_OLTP;
SELECT DISTINCT d.forename AS nom, d.surname AS cognom, r.raceId AS carrera, q.q1, q.q2, q.q3, r.fastestLapTime AS volta, q.position AS posicio
	FROM drivers AS d 
    JOIN results AS r ON r.driverId = d.driverId
    JOIN qualifying AS q ON q.raceID = r.raceId
	WHERE r.fastestLapTime <= ALL (SELECT q2.q1 FROM qualifying AS q2 JOIN results AS r2 ON q2.raceId = r2.raceId WHERE 
		r.driverId <> r2.driverId AND r.raceId = r2.raceId)
	AND r.fastestLapTime <= ALL (SELECT q3.q2 FROM qualifying AS q3 JOIN results AS r3 ON q3.raceId = r3.raceId WHERE
		r.driverId <> r3.driverId AND r.raceId = r3.raceId) 
	AND r.fastestLapTime <= ALL (SELECT q4.q3 FROM qualifying AS q4 JOIN results AS r4 ON q4.raceId = r4.raceId WHERE
		r.driverId <> r4.driverId AND r.raceId = r4.raceId)
	AND q.q1 > q.q2
    AND q.q2 > q.q3
    AND positionOrder BETWEEN 1 AND 3 
	AND q.q1 IS NOT NULL 
    AND q.q2 IS NOT NULL 
    AND q.q3 IS NOT NULL;

USE localOlap;
SELECT DISTINCT cd.forenameD AS nom, cd.surnameD AS cognom, ir.raceId AS carrera, ir.q1Q, ir.q2Q, ir.q3Q, ir.fastestLapTimeR AS volta, ir.positionQ AS posicio
	FROM infoResult AS ir JOIN constructorDriver AS cd ON ir.driverId = cd.driverId 
	WHERE ir.fastestLapTimeR <= ALL (SELECT ir2.q1Q FROM infoResult AS ir2 WHERE ir.raceId = ir2.raceId AND 
		ir.driverId <> ir2.driverId)
	AND ir.fastestLapTimeR <= ALL (SELECT ir3.q2Q FROM infoResult AS ir3 WHERE ir.raceId = ir3.raceId AND 
		ir.driverId <> ir3.driverId) 
	AND ir.fastestLapTimeR <= ALL (SELECT ir4.q3Q FROM infoResult AS ir4 WHERE ir.raceId = ir4.raceId AND 
		ir.driverId <> ir4.driverId)
	AND ir.q1Q > ir.q2Q 
    AND ir.q2Q > ir.q3Q 
    AND positionOrderR BETWEEN 1 AND 3 
	AND ir.q1Q IS NOT NULL 
    AND ir.q2Q IS NOT NULL 
    AND ir.q3Q IS NOT NULL;


-- Search for the drivers (complete name), the fastest speed and lap time and circuit name where the drivers have recorded the fastest lap in the race, 
-- but not the highest speed or the other way around.
DROP TABLE IF EXISTS querie4 CASCADE;
CREATE TABLE IF NOT EXISTS querie4(
	raceId INT(11),
	driverId INT(11),
    fastestLapTime time
);

INSERT INTO querie4(raceId, driverId, fastestLapTime)
SELECT raceId, driverId, MAX(time)
FROM F1_OLTP.lapTimes
GROUP BY raceId, driverId;
SELECT * FROM querie4;

(SELECT d.forenameD, d.surnameS, r.fastestLapSpeedR, q.fastestLapTime FROM F1_OLTP.drivers AS d 
	JOIN F1_OLTP.results AS r ON d.driverId = r.driverId 
    JOIN querie4 AS q ON r.raceId = q.raceId);
    

-- Check the biggest overtaking (specifying the driver’s complete name, circuit, year and overtaking positions) in the F1 history, for the whole race 
-- (do not take into account the first lap), and in a lap period.
USE localOlap;
(SELECT DISTINCT d.forenameD, d.surnameD, ir.circuitId, ir.yearR, ire.gridR-ire.positionOrderR AS overtakingPositions FROM constructorDriver AS d
JOIN infoResult AS ire ON ire.driverId = d.driverId
JOIN infoRace AS ir ON ire.raceId = ir.RaceId
WHERE ire.gridR-ire.positionOrderR = (SELECT MAX(ire2.gridR-ire2.positionOrderR) FROM infoResult AS ire2));

USE localOlap;
SELECT * FROM infoResult WHERE
raceId = 12345;





