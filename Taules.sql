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


/* SELECT * from F1_OLTP.circuits;
SELECT * from F1_OLTP.constructorResults;
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


