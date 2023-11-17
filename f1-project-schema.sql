#schema showing database creation for f1_project

CREATE DATABASE `f1_project` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

#create tables

CREATE TABLE `circuits` (
  `circuitId` int DEFAULT NULL,
  `circuitRef` text,
  `name` text,
  `location` text,
  `country` text,
  `lat` double DEFAULT NULL,
  `lng` double DEFAULT NULL,
  `alt` int DEFAULT NULL,
  `url` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `constructor_results` (
  `constructorResultsId` int DEFAULT NULL,
  `raceId` int DEFAULT NULL,
  `constructorId` int DEFAULT NULL,
  `points` int DEFAULT NULL,
  `status` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `constructor_standings` (
  `constructorStandingsId` int DEFAULT NULL,
  `raceId` int DEFAULT NULL,
  `constructorId` int DEFAULT NULL,
  `points` int DEFAULT NULL,
  `position` int DEFAULT NULL,
  `positionText` int DEFAULT NULL,
  `wins` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `drivers` (
  `driverId` int DEFAULT NULL,
  `driverRef` text,
  `number` int DEFAULT NULL,
  `code` text,
  `forename` text,
  `surname` text,
  `dob` text,
  `nationality` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `driver_standings` (
  `driverStandingsId` int DEFAULT NULL,
  `raceId` int DEFAULT NULL,
  `driverId` int DEFAULT NULL,
  `points` int DEFAULT NULL,
  `position` int DEFAULT NULL,
  `positionText` int DEFAULT NULL,
  `wins` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `races` (
  `raceId` int DEFAULT NULL,
  `year` int DEFAULT NULL,
  `round` int DEFAULT NULL,
  `circuitId` int DEFAULT NULL,
  `name` text,
  `date` text,
  `time` text,
  `url` text,
  `fp1_date` text,
  `fp1_time` text,
  `fp2_date` text,
  `fp2_time` text,
  `fp3_date` text,
  `fp3_time` text,
  `quali_date` text,
  `quali_time` text,
  `sprint_date` text,
  `sprint_time` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `results` (
  `ResultId` int DEFAULT NULL,
  `RaceID` int DEFAULT NULL,
  `driverID` int DEFAULT NULL,
  `constructorId` int DEFAULT NULL,
  `number` int DEFAULT NULL,
  `grid` int DEFAULT NULL,
  `position` int DEFAULT NULL,
  `positionText` int DEFAULT NULL,
  `positionOrder` int DEFAULT NULL,
  `points` int DEFAULT NULL,
  `laps` int DEFAULT NULL,
  `time` text,
  `fastestLap` int DEFAULT NULL,
  `Rank` int DEFAULT NULL,
  `fastestLapTime` text,
  `fastestLapSpeed` double DEFAULT NULL,
  `statusId` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

#insert data into tables

INSERT INTO `f1_project`.`circuits`
(`circuitId`,
`circuitRef`,
`name`,
`location`,
`country`,
`lat`,
`lng`,
`alt`,
`url`)
VALUES
(<{circuitId: }>,
<{circuitRef: }>,
<{name: }>,
<{location: }>,
<{country: }>,
<{lat: }>,
<{lng: }>,
<{alt: }>,
<{url: }>);

INSERT INTO `f1_project`.`constructor_results`
(`constructorResultsId`,
`raceId`,
`constructorId`,
`points`,
`status`)
VALUES
(<{constructorResultsId: }>,
<{raceId: }>,
<{constructorId: }>,
<{points: }>,
<{status: }>);

INSERT INTO `f1_project`.`constructor_standings`
(`constructorStandingsId`,
`raceId`,
`constructorId`,
`points`,
`position`,
`positionText`,
`wins`)
VALUES
(<{constructorStandingsId: }>,
<{raceId: }>,
<{constructorId: }>,
<{points: }>,
<{position: }>,
<{positionText: }>,
<{wins: }>);

INSERT INTO `f1_project`.`drivers`
(`driverId`,
`driverRef`,
`number`,
`code`,
`forename`,
`surname`,
`dob`,
`nationality`)
VALUES
(<{driverId: }>,
<{driverRef: }>,
<{number: }>,
<{code: }>,
<{forename: }>,
<{surname: }>,
<{dob: }>,
<{nationality: }>);

INSERT INTO `f1_project`.`driver_standings`
(`driverStandingsId`,
`raceId`,
`driverId`,
`points`,
`position`,
`positionText`,
`wins`)
VALUES
(<{driverStandingsId: }>,
<{raceId: }>,
<{driverId: }>,
<{points: }>,
<{position: }>,
<{positionText: }>,
<{wins: }>);

INSERT INTO `f1_project`.`races`
(`raceId`,
`year`,
`round`,
`circuitId`,
`name`,
`date`,
`time`,
`url`,
`fp1_date`,
`fp1_time`,
`fp2_date`,
`fp2_time`,
`fp3_date`,
`fp3_time`,
`quali_date`,
`quali_time`,
`sprint_date`,
`sprint_time`)
VALUES
(<{raceId: }>,
<{year: }>,
<{round: }>,
<{circuitId: }>,
<{name: }>,
<{date: }>,
<{time: }>,
<{url: }>,
<{fp1_date: }>,
<{fp1_time: }>,
<{fp2_date: }>,
<{fp2_time: }>,
<{fp3_date: }>,
<{fp3_time: }>,
<{quali_date: }>,
<{quali_time: }>,
<{sprint_date: }>,
<{sprint_time: }>);

INSERT INTO `f1_project`.`results`
(`ResultId`,
`RaceID`,
`driverID`,
`constructorId`,
`number`,
`grid`,
`position`,
`positionText`,
`positionOrder`,
`points`,
`laps`,
`time`,
`fastestLap`,
`Rank`,
`fastestLapTime`,
`fastestLapSpeed`,
`statusId`)
VALUES
(<{ResultId: }>,
<{RaceID: }>,
<{driverID: }>,
<{constructorId: }>,
<{number: }>,
<{grid: }>,
<{position: }>,
<{positionText: }>,
<{positionOrder: }>,
<{points: }>,
<{laps: }>,
<{time: }>,
<{fastestLap: }>,
<{Rank: }>,
<{fastestLapTime: }>,
<{fastestLapSpeed: }>,
<{statusId: }>);

#database is now prepared for analysis
