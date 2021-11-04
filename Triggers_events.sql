DROP DATABASE IF EXISTS F1_OLTP;
CREATE DATABASE F1_OLTP;
USE F1_OLTP;

-- Crea OLTP
DELIMITER $$
DROP PROCEDURE IF EXISTS Create_oltp $$
CREATE PROCEDURE Create_oltp()
BEGIN 
	SET FOREIGN_KEY_CHECKS=0;

    
	DROP TABLE IF EXISTS circuits CASCADE;
	CREATE TABLE IF NOT EXISTS circuits (
		circuitId INT (11) auto_increment,
		circuitRef VARCHAR (255),
		name VARCHAR (255),
		location VARCHAR (255),
		country VARCHAR (255),
		lat float,
		lng float,
		alt int(11),
		url VARCHAR (255),
        PRIMARY KEY (circuitId)
        
	);
    
	DROP TABLE IF EXISTS seasons CASCADE;
	CREATE TABLE IF NOT EXISTS seasons (
		year INT (11),
		url VARCHAR (255),
        PRIMARY KEY (year)
	);
    
	DROP TABLE IF EXISTS races CASCADE;
	CREATE TABLE IF NOT EXISTS races (
		raceId INT (11) auto_increment,
		year INT (11),
		round INT (11),
		circuitId INT (11),
		name VARCHAR (255),
		date date,
		time time DEFAULT '00:00:00',
		url VARCHAR (255),
        PRIMARY KEY (raceId)
        -- FOREIGN KEY (circuitId) REFERENCES circuits(circuitId),
        -- FOREIGN KEY (year) REFERENCES seasons(year) 
	);
    
	DROP TABLE IF EXISTS constructors CASCADE;
	CREATE TABLE IF NOT EXISTS constructors (
		constructorId INT (11) auto_increment,
		constructorRef VARCHAR (255),
		name VARCHAR (255),
		nationality VARCHAR (255),
		url VARCHAR (255),
        PRIMARY KEY (constructorId)
	);

	DROP TABLE IF EXISTS constructorResults CASCADE;
	CREATE TABLE IF NOT EXISTS constructorResults (
		constructorResultsId INT (11) auto_increment,
		raceId INT (11),
		constructorId INT (11),
		points float,
		status VARCHAR (255),
        PRIMARY KEY (constructorResultsId),
		FOREIGN KEY (raceId) REFERENCES races(raceId) 
	);

	DROP TABLE IF EXISTS constructorStandings CASCADE;
	CREATE TABLE IF NOT EXISTS constructorStandings (
		constructorStandingsId INT (11) auto_increment,
		raceId INT (11),
		constructorId INT (11),
		points float,
		position INT (11),
		positionText VARCHAR (255),
		wins INT (11),
        PRIMARY KEY (constructorStandingsId),
        FOREIGN KEY (raceId) REFERENCES races(raceId) 
	);


	DROP TABLE IF EXISTS drivers CASCADE;
	CREATE TABLE IF NOT EXISTS drivers (
		driverId INT (11) AUTO_INCREMENT,
		driverRef VARCHAR (255),
		number INT(11),
		code VARCHAR (10),
		forename VARCHAR (255),
		surname VARCHAR (255),
		dob date,
		nationality VARCHAR (255),
		url VARCHAR (300),
        PRIMARY KEY (driverId)
        
	);

	DROP TABLE IF EXISTS driverStandings CASCADE;
	CREATE TABLE IF NOT EXISTS driverStandings (
		driverStandingsId INT (11) AUTO_INCREMENT,
		raceId INT (11),
		driverId INT (11),
		points float,
		position INT (11),
		positionText VARCHAR (255),
		wins INT (11),
        PRIMARY KEY (driverStandingsId),
        FOREIGN KEY (raceId) REFERENCES races(raceId)
	);


	DROP TABLE IF EXISTS lapTimes CASCADE;
	CREATE TABLE IF NOT EXISTS lapTimes (
		raceId INT (11),
		driverId INT (11),
		lap INT (11),
		position INT (11),
		time VARCHAR (255),
		milliseconds INT (11),
        PRIMARY KEY (raceId, driverId, lap),
        FOREIGN KEY (raceId) REFERENCES races(raceId),
        FOREIGN KEY (driverId) REFERENCES drivers(driverId)
	);

	DROP TABLE IF EXISTS pitStops CASCADE;
	CREATE TABLE IF NOT EXISTS pitStops (
		raceId INT (11),
		driverId INT (11),
		stop INT (11),
		lap INT (11),
		time time,
		duration VARCHAR (255),
		milliseconds INT (11),
        PRIMARY KEY (raceId,driverId, stop),
        FOREIGN KEY (raceId) REFERENCES races(raceId),
        FOREIGN KEY (driverId) REFERENCES drivers(driverId)
	);


	DROP TABLE IF EXISTS qualifying CASCADE;
	CREATE TABLE IF NOT EXISTS qualifying (
		qualifyId INT (11) AUTO_INCREMENT,
		raceId INT (11),
		driverId INT (11),
		constructorId INT (11),
		number INT (11),
		position INT (11),
		q1 VARCHAR (255),
		q2 VARCHAR (255),
		q3 VARCHAR (255),
        PRIMARY KEY (qualifyId),
        FOREIGN KEY (raceId) REFERENCES races(raceId)
	);
    
    	DROP TABLE IF EXISTS status CASCADE;
		CREATE TABLE IF NOT EXISTS status (
		statusId INT (11) AUTO_INCREMENT,
		status VARCHAR (255),
        PRIMARY KEY (statusId)
	);

    
	DROP TABLE IF EXISTS results CASCADE;
	CREATE TABLE IF NOT EXISTS results (
		resultId INT (11) AUTO_INCREMENT,
		raceId INT (11),
		driverId INT (11),
        constructorId INT (11),
        number INT (11) default NULL,
        grid INT (11), -- posicio de sortida
		position INT (11) default NULL,
		positionText VARCHAR (255),
		positionOrder INT (11),
		points float,
        laps INT (11),
        time VARCHAR (255) DEFAULT NULL,
        milliseconds INT (11) DEFAULT NULL,
		fastestLap INT (11) DEFAULT NULL,
        rank INT (11),
        fastestLapTime VARCHAR (255) DEFAULT NULL,
        fastestLapSpeed VARCHAR (255) DEFAULT NULL,
        statusId INT(11),
        PRIMARY KEY (resultId),
		FOREIGN KEY (raceId) REFERENCES races(raceId)
	);
    
	SET FOREIGN_KEY_CHECKS=1;
    
    
END $$
DELIMITER ;

CALL Create_oltp();


-- SELECT * from F1_OLTP.circuits;
/*SELECT * from F1_OLTP.constructorResults;
SELECT * from F1_OLTP.constructorStandings;
SELECT * from F1_OLTP.constructors;
SELECT * from F1_OLTP.driverStandings;
SELECT * from F1_OLTP.drivers;
SELECT * from F1_OLTP.lapTimes;
SELECT * from F1_OLTP.pitStops;
SELECT * from F1_OLTP.qualifying;
SELECT * from F1_OLTP.races;
SELECT * from F1_OLTP.results;
SELECT * from F1_OLTP.seasons;
SELECT * from F1_OLTP.status;*/







-- Crea OLAP
DROP DATABASE IF EXISTS localOlap;
CREATE DATABASE localOlap;
USE localOlap;

DELIMITER $$
DROP PROCEDURE IF EXISTS CreaBBDD_olap $$
CREATE PROCEDURE CreaBBDD_olap()
BEGIN 
	SET FOREIGN_KEY_CHECKS=0;
    
	DROP TABLE IF EXISTS infoRace CASCADE;
    CREATE table IF NOT EXISTS infoRace(
        circuitId int(11) default NULL,
        circuitRefC VARCHAR (255) default NULL,
		nameC VARCHAR (255) default NULL,
		locationC VARCHAR (255) default NULL,
		countryC VARCHAR (255) default NULL,
		latC float default NULL,
		lngC float default NULL,
		altC int(11) default NULL,
		urlC VARCHAR (255) default NULL,
        
        raceId int(11),
        urlR VARCHAR (255) default NULL,
        yearR INT (11) default NULL,
		roundR INT (11) default NULL,
        nameR varchar (255) default NULL,
        dateR date default NULL,
		timeR time default NULL,
        
        urlS VARCHAR (255) default NULL
        
	);
    
    
	DROP TABLE IF EXISTS constructorDriver CASCADE;
	CREATE TABLE IF NOT EXISTS constructorDriver (
		constructorId INT (11) default NULL,
        constructorRefC VARCHAR (255) default NULL,
        nameC VARCHAR(255) default NULL,
        nationalityC VARCHAR (255) default NULL,
        urlC VARCHAR (255) default NULL,
	
		driverId INT (11) default NULL,
		driverRefD VARCHAR (255) default NULL,
		numberD INT(11) default NULL,
		codeD VARCHAR (10) default NULL,
		forenameD VARCHAR (255)default NULL,
		surnameD VARCHAR (255) default NULL,
		dobD date default NULL,
		nationalityD VARCHAR (255) default NULL,
		urlD VARCHAR (255) default NULL
        
    );
        
        
    DROP TABLE IF EXISTS infoResult CASCADE;
    CREATE table IF NOT EXISTS infoResult (
		resultId int(11),
		raceId int(11) default NULL,
		constructorId INT (11) default NULL,
		driverId INT (11) default NULL,
        numberR INT (11) default NULL,
        gridR INT (11) default NULL,
		positionR INT (11) default NULL,
        positionTextR VARCHAR (255) default NULL,
		positionOrderR INT (11) default NULL,
		pointsR float default NULL,
        lapsR INT (11) default NULL, 
        timeR VARCHAR (255) DEFAULT NULL,
        millisecondsR INT (11) DEFAULT NULL,
		fastestLapR INT (11) DEFAULT NULL,
        rankR INT (11) default NULL,
        fastestLapTimeR VARCHAR (255) DEFAULT NULL,
        fastestLapSpeedR VARCHAR (255) DEFAULT NULL,
        statusIdR INT(11) default NULL,
        
        status VARCHAR (255) default NULL,
        
        qualifyId int (11) default NULL,
        numberQ INT (11) default NULL,
        positionQ INT (11) default NULL,
		q1Q VARCHAR (255) default NULL,
		q2Q VARCHAR (255) default NULL,
		q3Q VARCHAR (255) default NULL,
        
        constructorStandingsIdCS int(11) default NULL,
        pointsCS float default NULL,
        positionCS INT (11) default NULL,
        positionTextCS VARCHAR (255) default NULL,
        winsCS INT (11) default NULL,
        
        constructorResultsIdCR int(11) default NULL,
        pointsCR float default NULL,
        statusCR VARCHAR(255) default NULL,
        
        driverStandingsIdDS int(11) default NULL,
        pointsDS float default NULL,
		positionDS INT (11) default NULL,
		positionTextDS VARCHAR (255) default NULL,
		winsDS INT (11)default NULL
        
	);
    
    
    DROP TABLE IF EXISTS infoLaps CASCADE;
    CREATE table IF NOT EXISTS infoLaps (
		raceId int(11) default NULL,
		driverId INT (11) default NULL,
		lapL int(11) default NULL,
        positionL INT (11) default NULL,
        timeL TIME default NULL,
        millisecondsL int (11) default NULL,
        
        stopP INT (11) default NULL,
        timeP TIME default NULL,
        durationP VARCHAR (255) default NULL, 
        millisecondsP INT (11) DEFAULT NULL
        
	);
    
	SET FOREIGN_KEY_CHECKS=1;
END $$
DELIMITER ;

call CreaBBDD_olap();




-- OMPLIM INFORACES        
USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoRace1 $$
CREATE TRIGGER F1_OLTP.trigger_infoRace1 AFTER INSERT ON F1_OLTP.races FOR EACH ROW

BEGIN
	INSERT INTO localOlap.infoRace(raceId, yearR, roundR, nameR, dateR, timeR, urlR, circuitId)
	VALUES ((SELECT (raceId) FROM F1_OLTP.races WHERE raceId = NEW.raceId), NEW.year, NEW.round, NEW.name, NEW.date, NEW.time, NEW.url, NEW.circuitId); 
END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoRace2 $$
CREATE TRIGGER F1_OLTP.trigger_infoRace2 AFTER INSERT ON F1_OLTP.circuits FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoRace.circuitId FROM localOlap.infoRace where new.circuitId = localOlap.infoRace.circuitId)  THEN
	UPDATE localOlap.infoRace SET circuitRefC = new.circuitRef, nameC = new.name, locationC = new.location, countryC = new.country, latC = new.lat, lngC = new.lng, altC = new.alt, urlC = new.url WHERE new.circuitId = localOlap.infoRace.circuitId;  

ELSE 
	INSERT INTO localOlap.infoRace(circuitId, circuitRefC, nameC, locationC, countryC, latC, lngC, altC, urlC)
	VALUES (new.circuitId, new.circuitRef, new.name, new.location, new.country, new.lat, new.lng, new.alt, new.url);
END IF;
    
END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoRace3 $$
CREATE TRIGGER F1_OLTP.trigger_infoRace3 AFTER INSERT ON F1_OLTP.seasons FOR EACH ROW

BEGIN
	UPDATE localOlap.infoRace SET urlS = new.url WHERE new.year = localOlap.infoRace.yearR;  
    
END $$

DELIMITER ;



-- OMPLIM INFOLAPS
USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoLaps1 $$
CREATE TRIGGER F1_OLTP.trigger_infoLaps1 AFTER INSERT ON F1_OLTP.lapTimes FOR EACH ROW
BEGIN
	INSERT INTO localOlap.infoLaps(raceId, driverId, lapL, positionL, timeL, millisecondsL)
	VALUES (new.raceId, new.driverId, new.lap, new.position, new.time, new.milliseconds);
	
END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoLaps2 $$
CREATE TRIGGER F1_OLTP.trigger_infoLaps2 AFTER INSERT ON F1_OLTP.pitStops FOR EACH ROW


BEGIN
	UPDATE localOlap.infoLaps SET stopP = new.stop, timeP = new.time, durationP = new.duration, millisecondsP = new.milliseconds WHERE localOlap.infoLaps.raceId = new.raceId AND localOlap.infoLaps.driverId = new.driverId AND localOlap.infoLaps.lapL = NEW.lap;  
    
END $$

DELIMITER ;



-- OMPLIM INFORESULT I CONSTRUCTORDRIVER
USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult1 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult1 AFTER INSERT ON F1_OLTP.results FOR EACH ROW

BEGIN
IF NOT EXISTS (SELECT localOlap.constructorDriver.driverId, localOlap.constructorDriver.constructorId FROM localOlap.constructorDriver WHERE localOlap.constructorDriver.constructorId = new.constructorId AND localOlap.constructorDriver.driverId = new.driverId) THEN
	INSERT INTO localOlap.constructorDriver(driverId, constructorId, driverRefD, numberD, codeD, forenameD, surnameD, dobD, nationalityD, urlD, constructorRefC, nameC, nationalityC, urlC)
	VALUES (new.driverId, new.constructorId, (SELECT F1_OLTP.drivers.driverRef FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId), 
    (SELECT F1_OLTP.drivers.number FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.code FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.forename FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.surname FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.dob FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.nationality FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.drivers.url FROM F1_OLTP.drivers WHERE F1_OLTP.drivers.driverId = new.driverId),
    (SELECT F1_OLTP.constructors.constructorRef FROM F1_OLTP.constructors WHERE F1_OLTP.constructors.constructorId = new.constructorId),
    (SELECT F1_OLTP.constructors.name FROM F1_OLTP.constructors WHERE F1_OLTP.constructors.constructorId = new.constructorId),
    (SELECT F1_OLTP.constructors.nationality FROM F1_OLTP.constructors WHERE F1_OLTP.constructors.constructorId = new.constructorId),
    (SELECT F1_OLTP.constructors.url FROM F1_OLTP.constructors WHERE F1_OLTP.constructors.constructorId = new.constructorId));
    
END IF;

	INSERT INTO localOlap.infoResult(resultId, raceId, driverId, constructorId, numberR, gridR, positionR, positionTextR, positionOrderR, pointsR, lapsR, timeR, millisecondsR, fastestLapR, fastestLapTimeR, fastestLapSpeedR, statusIdR)
	VALUES (new.resultId, new.raceId, new.driverId, new.constructorId, new.number, new.grid, new.position, new.positionText, new.positionOrder, new.points, new.laps, new.time, new.milliseconds, new.fastestLap, new.fastestLapTime, new.fastestLapSpeed, new.statusId);

END $$

DELIMITER ;

SET FOREIGN_KEY_CHECKS=0;
	INSERT INTO F1_OLTP.results(raceId, driverId, constructorId, number, grid, position, positionText, positionOrder, points, laps, time, milliseconds, fastestLap, fastestLapTime, fastestLapSpeed, statusId)
	VALUES (12345, 20, 45, 56, 21, 12, '12', 12, 3, 21, null, null, 3, null, null, 23);


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult2 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult2 AFTER INSERT ON F1_OLTP.qualifying FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoResult.raceId, localOlap.infoResult.driverId, localOlap.infoResult.constructorId FROM  localOlap.infoResult WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.driverId = new.driverId AND localOlap.infoResult.constructorId = new.constructorId)  THEN
	UPDATE localOlap.infoResult SET qualifyId = new.qualifyId, numberQ = new.number, positionQ = new.position, q1Q = new.q1, q2Q = new.q2, q3Q = new.q3 WHERE (localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.driverId = new.driverId AND localOlap.infoResult.constructorId = new.constructorId);  

ELSE 
	INSERT INTO localOlap.infoResult(qualifyId, raceId, driverId, constructorId, numberQ, positionQ, q1Q, q2Q, q3Q)
    VALUES (new.qualifyId, new.raceId, new.driverId, new.constructorId, new.number, new.position, new.q1, new.q2, new.q3);
END IF;

END $$

DELIMITER ;

SET FOREIGN_KEY_CHECKS=0;
INSERT INTO F1_OLTP.constructorStandings(raceId, constructorId, points, position, positionText, wins)
    VALUES (12345, 45, 56, 12, '12', 12);

USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult3 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult3 AFTER INSERT ON F1_OLTP.status FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoResult.statusIdR FROM localOlap.infoResult where localOlap.infoResult.statusIdR = new.statusId)  THEN
	UPDATE localOlap.infoResult SET status = new.status where localOlap.infoResult.statusIdR = new.statusId;  

ELSE 
	INSERT INTO localOlap.infoResult(statusIdR, status)
	VALUES (new.statusId, new.status);
END IF;

END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult4 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult4 AFTER INSERT ON F1_OLTP.driverStandings FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoResult.raceId, localOlap.infoResult.driverId FROM  localOlap.infoResult WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.driverId = new.driverId)  THEN
	UPDATE localOlap.infoResult SET driverStandingsIdDS = new.driverStandingsId, pointsDS = new.points, positionDS = new.position, positionTextDS = new.positionText, winsDS = new.wins WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.driverId = new.driverId;  

ELSE 
	INSERT INTO localOlap.infoResult(raceId, driverId, driverStandingsIdDS, pointsDS, positionDS, positionTextDS, winsDS)
	VALUES (new.raceId, new.driverId, new.driverStandingsId, new.points, new.position, new.positionText, new.wins);
END IF;

END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult5 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult5 AFTER INSERT ON F1_OLTP.constructorStandings FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoResult.raceId, localOlap.infoResult.constructorId FROM  localOlap.infoResult WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.constructorId = new.constructorId)  THEN
	UPDATE localOlap.infoResult SET constructorStandingsIdCS = new.constructorStandingsId, pointsCS = new.points, positionCS = new.position, positionTextCS = new.positionText, winsCS = new.wins WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.constructorId = new.constructorId;  

ELSE 
	INSERT INTO localOlap.infoResult(raceId, constructorId, constructorStandingsIdCS, pointsCS, positionCS, positionTextCS, winsCS)
	VALUES (new.raceId, new.constructorId, new.constructorStandingsId, new.points, new.position, new.positionText, new.wins);
END IF;

END $$

DELIMITER ;


USE F1_OLTP;
DELIMITER $$
DROP TRIGGER IF EXISTS F1_OLTP.trigger_infoResult6 $$
CREATE TRIGGER F1_OLTP.trigger_infoResult6 AFTER INSERT ON F1_OLTP.constructorResults FOR EACH ROW

BEGIN
IF EXISTS (SELECT localOlap.infoResult.raceId, localOlap.infoResult.constructorId FROM  localOlap.infoResult WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.constructorId = new.constructorId)  THEN
	UPDATE localOlap.infoResult SET constructorResultsIdCR = new.constructorResultsId, pointsCR = new.points, statusCR = new.status WHERE localOlap.infoResult.raceId = new.raceId AND localOlap.infoResult.constructorId = new.constructorId;  
    
ELSE 
	INSERT INTO localOlap.infoResult(raceId, constructorId, constructorResultsIdCR, pointsCR, statusCR)
	VALUES (new.raceId, new.constructorId, new.constructorResultsId, new.points, new.status);
END IF;

END $$

DELIMITER ;



use F1_OLTP;
SHOW TRIGGERS;

USE localOlap;
SELECT * FROM localOlap.infoRace;
SELECT * FROM localOlap.constructorDriver;
SELECT * FROM localOlap.infoResult;
SELECT * FROM localOlap.infoLaps;


DROP TABLE IF EXISTS comprovacioEvent CASCADE;
CREATE TABLE IF NOT EXISTS comprovacioEvent (
	dia date,
	taula VARCHAR(50),
	filesOltp int(11),
	filesOlap int(11),
	importacio VARCHAR(50)
);


SET GLOBAL event_scheduler = ON;


DELIMITER $$
DROP EVENT IF EXISTS comprovaOLAP$$
CREATE EVENT IF NOT EXISTS comprovaOLAP
ON SCHEDULE EVERY 1 day
-- STARTS	CURRENT_TIMESTAMP()	+ INTERVAL 5 hour
DO 
BEGIN
	
    
    IF ((SELECT COUNT(DISTINCT raceId) FROM F1_OLTP.races) = (SELECT COUNT(DISTINCT raceId) FROM localOlap.infoRace)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'races', (SELECT COUNT(DISTINCT raceId) FROM F1_OLTP.races), (SELECT COUNT(DISTINCT raceId) FROM localOlap.infoRace), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'races', (SELECT COUNT(DISTINCT raceId) FROM F1_OLTP.races), (SELECT COUNT(DISTINCT raceId) FROM localOlap.infoRace), 'KO');
        
	END IF;
    

    IF ((SELECT COUNT(DISTINCT circuitId) FROM F1_OLTP.circuits) = (SELECT COUNT(DISTINCT circuitId) FROM localOlap.infoRace)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'circuits', (SELECT COUNT(DISTINCT circuitId) FROM F1_OLTP.circuits), (SELECT COUNT(DISTINCT circuitId) FROM localOlap.infoRace), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'circuits', (SELECT COUNT(DISTINCT circuitId) FROM F1_OLTP.circuits), (SELECT COUNT(DISTINCT circuitId) FROM localOlap.infoRace), 'KO');
        
	END IF;
    
    
	IF ((SELECT COUNT(DISTINCT url) FROM F1_OLTP.seasons) = (SELECT COUNT(DISTINCT urlS) FROM localOlap.infoRace)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'seasons', (SELECT COUNT(DISTINCT url) FROM F1_OLTP.seasons), (SELECT COUNT(DISTINCT urlS) FROM localOlap.infoRace), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'seasons', (SELECT COUNT(DISTINCT url) FROM F1_OLTP.seasons), (SELECT COUNT(DISTINCT urlS) FROM localOlap.infoRace), 'KO');
        
	END IF;


	IF ((SELECT COUNT(DISTINCT constructorId) FROM F1_OLTP.constructors) = (SELECT COUNT(DISTINCT constructorId) FROM localOlap.constructorDriver)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructors', (SELECT COUNT(DISTINCT constructorId) FROM F1_OLTP.constructors), (SELECT COUNT(DISTINCT constructorId) FROM localOlap.constructorDriver), 'OK');

	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructors', (SELECT COUNT(DISTINCT constructorId) FROM F1_OLTP.constructors), (SELECT COUNT(DISTINCT constructorId) FROM localOlap.constructorDriver), 'KO');

	END IF;

    
    IF ((SELECT COUNT(DISTINCT driverId) FROM F1_OLTP.drivers) = (SELECT COUNT(DISTINCT driverId) FROM localOlap.constructorDriver)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'drivers', (SELECT COUNT(DISTINCT driverId) FROM F1_OLTP.drivers), (SELECT COUNT(DISTINCT driverId) FROM localOlap.constructorDriver), 'OK');	
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'drivers', (SELECT COUNT(DISTINCT driverId) FROM F1_OLTP.drivers), (SELECT COUNT(DISTINCT driverId) FROM localOlap.constructorDriver), 'KO');	
        
	END IF;
    

	IF ((SELECT COUNT(DISTINCT constructorResultsId) FROM F1_OLTP.constructorResults) = (SELECT COUNT(DISTINCT constructorResultsIdCR) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructorResults', (SELECT COUNT(DISTINCT constructorResultsId) FROM F1_OLTP.constructorResults), (SELECT COUNT(DISTINCT constructorResultsIdCR) FROM localOlap.infoResult), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructorResults', (SELECT COUNT(DISTINCT constructorResultsId) FROM F1_OLTP.constructorResults), (SELECT COUNT(DISTINCT constructorResultsIdCR) FROM localOlap.infoResult), 'KO');
        
	END IF;
    

	IF ((SELECT COUNT(DISTINCT constructorStandingsId) FROM F1_OLTP.constructorStandings) = (SELECT COUNT(DISTINCT constructorStandingsIdCS) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructorStandings', (SELECT COUNT(DISTINCT constructorStandingsId) FROM F1_OLTP.constructorStandings), (SELECT COUNT(DISTINCT constructorStandingsIdCS) FROM localOlap.infoResult), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'constructorStandings', (SELECT COUNT(DISTINCT constructorStandingsId) FROM F1_OLTP.constructorStandings), (SELECT COUNT(DISTINCT constructorStandingsIdCS) FROM localOlap.infoResult), 'KO');
        
	END IF;
    

	IF ((SELECT COUNT(DISTINCT driverStandingsId) FROM F1_OLTP.driverStandings) = (SELECT COUNT(DISTINCT driverStandingsIdDS) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'driverStandings', (SELECT COUNT(DISTINCT driverStandingsId) FROM F1_OLTP.driverStandings), (SELECT COUNT(DISTINCT driverStandingsIdDS) FROM localOlap.infoResult), 'OK');
    
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'driverStandings', (SELECT COUNT(DISTINCT driverStandingsId) FROM F1_OLTP.driverStandings), (SELECT COUNT(DISTINCT driverStandingsIdDS) FROM localOlap.infoResult), 'KO');
    
	END IF;
    
    
	IF ((SELECT COUNT(DISTINCT statusId) FROM F1_OLTP.status) = (SELECT COUNT(DISTINCT statusIdR) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'status', (SELECT COUNT(DISTINCT statusId) FROM F1_OLTP.status), (SELECT COUNT(DISTINCT statusIdR) FROM localOlap.infoResult), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'status', (SELECT COUNT(DISTINCT statusId) FROM F1_OLTP.status), (SELECT COUNT(DISTINCT statusIdR) FROM localOlap.infoResult), 'KO');
        
	END IF;
    
    
	IF ((SELECT COUNT(DISTINCT resultId) FROM F1_OLTP.results) = (SELECT COUNT(DISTINCT resultId) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'results', (SELECT COUNT(DISTINCT resultId) FROM F1_OLTP.results), (SELECT COUNT(DISTINCT resultId) FROM localOlap.infoResult), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'results', (SELECT COUNT(DISTINCT resultId) FROM F1_OLTP.results), (SELECT COUNT(DISTINCT resultId) FROM localOlap.infoResult), 'OK');
        
	END IF;
 

	IF ((SELECT COUNT(DISTINCT qualifyId) FROM F1_OLTP.qualifying) = (SELECT COUNT(DISTINCT qualifyId) FROM localOlap.infoResult)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'qualifying', (SELECT COUNT(DISTINCT qualifyId) FROM F1_OLTP.qualifying), (SELECT COUNT(DISTINCT qualifyId) FROM localOlap.infoResult), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'qualifying', (SELECT COUNT(DISTINCT qualifyId) FROM F1_OLTP.qualifying), (SELECT COUNT(DISTINCT qualifyId) FROM localOlap.infoResult), 'KO');
        
	END IF;
 

	IF ((SELECT COUNT(lap) FROM F1_OLTP.lapTimes) = (SELECT COUNT(lapL) FROM localOlap.infoLaps)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'lapTimes', (SELECT COUNT(lap) FROM F1_OLTP.lapTimes), (SELECT COUNT(lapL) FROM localOlap.infoLaps), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'lapTimes', (SELECT COUNT(lap) FROM F1_OLTP.lapTimes), (SELECT COUNT(lapL) FROM localOlap.infoLaps), 'KO');
        
	END IF;
    

    IF ((SELECT COUNT(stop) FROM F1_OLTP.pitStops) = (SELECT COUNT(stopP) FROM localOlap.infoLaps)) THEN 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'pitStops', (SELECT COUNT(stop) FROM F1_OLTP.pitStops), (SELECT COUNT(stopP) FROM localOlap.infoLaps), 'OK');
        
	ELSE 
		INSERT INTO comprovacioEvent(dia, taula, filesOltp, filesOlap, importacio) 
		VALUES (now(), 'pitStops', (SELECT COUNT(stop) FROM F1_OLTP.pitStops), (SELECT COUNT(stopP) FROM localOlap.infoLaps), 'KO');
        
	END IF;
    
END $$
DELIMITER ;

SELECT * FROM comprovacioEvent;