-- Analysing Formula 1 data 1950-2020 using dataset from Kaggle 

-- GENERAL QUERIES

SELECT 
    *
FROM
    results;

-- Find driver who's competed in the most races (Alonso)

SELECT 
    results.driverId, 
    COUNT(results.RaceId), 
    drivers.surname, 
    drivers.forename
FROM
    results
        JOIN
    drivers ON results.driverId = drivers.driverId
GROUP BY driverId , drivers.surname, drivers.forename
ORDER BY COUNT(RaceId) DESC;

-- Investigating Alonso's career

SELECT 
    RaceID, driverID, 
    fastestLapTime, 
    fastestLapSpeed
FROM
    results
WHERE
    driverId = '4' AND fastestLapSpeed <> 0
ORDER BY fastestLapTime ASC;

SELECT 
    results.RaceID,
    driverID,
    fastestLapTime,
    fastestLapSpeed,
    races.circuitId,
    races.date,
    circuits.name
FROM
    results
        JOIN
    races ON results.RaceId = races.RaceID
    LEFT JOIN 
    circuits ON races.circuitId = circuits.circuitId
WHERE
    driverId = '4' AND fastestLapSpeed <> 0
ORDER BY fastestLapTime ASC;

-- See driver stats ordered by Fastest Lap Time

SELECT 
    results.RaceID,
    results.driverID,
    drivers.forename,
    drivers.surname, 
    fastestLapTime,
    fastestLapSpeed,
    races.circuitId,
    races.date,
    circuits.name
FROM
    results
        JOIN
    races ON results.RaceId = races.RaceID
        JOIN
    drivers ON results.driverId = drivers.driverId
        LEFT JOIN
    circuits ON races.circuitId = circuits.circuitId
WHERE
    fastestLapSpeed <> 0
ORDER BY fastestLapTime ASC;

-- This query shows us some unusually fast lap times for Bahrain 2020. Let's investigate further.
-- What are the fastest lap times for Bahrain?

SELECT 
    results.RaceID,
    fastestLapTime,
    races.circuitId,
    races.date,
    circuits.name
FROM
    results
        JOIN
    races ON results.RaceId = races.RaceID
        LEFT JOIN
    circuits ON races.circuitId = circuits.circuitId
WHERE
    fastestLapSpeed <> 0 AND circuits.name = 'Bahrain International Circuit'
ORDER BY fastestLapTime ASC;

-- The results show that after RaceID 1046, the next fastest times are over 30s slower, meaning we have an anomaly.
-- Further investigation shows this race was a one off, reformatted race due to COVID.
-- Therefore, it shall be discounted from this query.

-- See driver stats ordered by Fastest Lap Time excluding RaceID 1046
-- Fastest recorded lap up to 2020 is by Carlos Sainz at Red Bull Ring

SELECT 
    results.RaceID,
    results.driverID,
    drivers.forename,
    drivers.surname, 
    fastestLapTime,
    fastestLapSpeed,
    races.circuitId,
    races.date,
    circuits.name
FROM
    results
        JOIN
    races ON results.RaceId = races.RaceID
        JOIN
    drivers ON results.driverId = drivers.driverId
        LEFT JOIN
    circuits ON races.circuitId = circuits.circuitId
WHERE
    fastestLapSpeed <> 0 AND results.RaceID != '1046'
ORDER BY fastestLapTime ASC;

-- Fastest Lap by Track

SELECT circuits.name AS track,
       MIN(results.fastestLapTime) AS fastest_lap
FROM
    results
        JOIN
    races ON results.RaceId = races.RaceID
        JOIN
    drivers ON results.driverId = drivers.driverId
        LEFT JOIN
    circuits ON races.circuitId = circuits.circuitId
WHERE results.fastestLapTime AND circuits.name IS NOT NULL
GROUP BY circuits.name
ORDER BY fastest_lap ASC;

-- DRIVER PERFORMANCE ANALYSIS

-- Find career points leader (Hamilton)

SELECT 
    results.driverId,
    SUM(results.points) AS total_points,
    drivers.forename,
    drivers.surname
FROM
    results
        JOIN
    drivers ON results.driverId = drivers.driverId
GROUP BY results.driverId , drivers.forename , drivers.surname
ORDER BY total_points DESC;

-- Find highest avg points per race (Hamilton)

SELECT 
    results.driverId,
    AVG(results.points) AS average_points,
    COUNT(results.RaceId) AS total_races,
    drivers.surname,
    drivers.forename
FROM
    results
        JOIN
    drivers ON results.driverId = drivers.driverId
GROUP BY results.driverId , drivers.surname, drivers.forename
ORDER BY average_points DESC;

-- We can a see a bias towards modern drivers, which we know to be true as the points system has changed many times

-- Find the driver with the highest average career finish (min 20 races) (Ascari)

SELECT 
    r.driverId,
    AVG(NULLIF(CAST(r.position AS SIGNED), 0)) AS average_position,
    COUNT(r.RaceId) AS total_races,
    d.surname,
    d.forename
FROM results r
JOIN drivers d ON r.driverId = d.driverId
GROUP BY r.driverId, d.surname, d.forename
HAVING total_races > 20
ORDER BY average_position ASC
LIMIT 20;


-- Finding the driver with the lowest average career finish (min 20 races) (Mazepin)

SELECT 
    r.driverId,
    AVG(NULLIF(CAST(r.position AS SIGNED), 0)) AS average_position,
    COUNT(r.RaceId) AS total_races,
    d.surname,
    d.forename
FROM results r
JOIN drivers d ON r.driverId = d.driverId
GROUP BY r.driverId, d.surname, d.forename
HAVING total_races > 20
ORDER BY average_position DESC;

-- Dividing drivers into quartiles based on avg career points achieved (min 20 points)

SELECT 
    driverId, 
    surname, 
    forename, 
    total_points,
    experience_level,
    NTILE(4) OVER (ORDER BY total_points DESC) AS performance_quartile,
    AVG(total_points) OVER () AS ovr_avg_career_points
FROM (
    SELECT 
        r.driverId, 
        d.surname, 
        d.forename, 
        SUM(r.points) AS total_points,
        CASE
            WHEN COUNT(r.RaceId) <= 50 THEN '1-50 races'
            WHEN COUNT(r.RaceId) <= 100 THEN '51-100 races'
            WHEN COUNT(r.RaceId) <= 150 THEN '101-150 races'
            ELSE '151+ races'
        END as experience_level
    FROM results r
    JOIN drivers d ON r.driverId = d.driverId
    GROUP BY r.driverId, d.surname, d.forename
    HAVING SUM(r.points) > 20
) AS QuartileData
ORDER BY total_points DESC;


-- Dividing drivers into quartiles based on avg career finish position (min 20 races)

SELECT 
    driverId, 
    surname, 
    forename, 
    average_position, 
    total_races,
    experience_level,
    NTILE(4) OVER (PARTITION BY experience_level ORDER BY average_position) AS performance_quartile,
    AVG(average_position) OVER (PARTITION BY experience_level) AS ovr_avg_career_finish_position
FROM (
    SELECT 
        r.driverId,
        d.surname,
        d.forename,
        AVG(NULLIF(CAST(r.position AS SIGNED), 0)) AS average_position,
        COUNT(r.RaceId) AS total_races,
        CASE
            WHEN COUNT(r.RaceId) <= 50 THEN '1-50 races'
            WHEN COUNT(r.RaceId) <= 100 THEN '51-100 races'
            WHEN COUNT(r.RaceId) <= 150 THEN '101-150 races'
            ELSE '151+ races'
        END as experience_level
    FROM results r
    JOIN drivers d ON r.driverId = d.driverId
    WHERE r.position <> '0'
    GROUP BY r.driverId, d.surname, d.forename
    HAVING COUNT(r.RaceId) > 20
) AS QuartileData
ORDER BY experience_level, average_position ASC;

-- CONSTRUCTOR ANALYSIS

-- Finding the constructor with the highest average finish (min 20 races)

SELECT 
    results.constructorId,
    AVG(NULLIF(CAST(results.position AS SIGNED), 0)) AS average_position,
    COUNT(constructor_results.constructorResultsId) AS total_races
FROM
    results
JOIN
    constructor_results ON results.constructorId = constructor_results.constructorId
WHERE
    results.position NOT IN ('DNF', 'DSQ') -- Exclude non-numeric values
GROUP BY
    results.constructorId
HAVING
    COUNT(results.RaceId) > 20
ORDER BY
    average_position ASC;

-- Finding the constructor with the lowest average finish (min 20 races)

SELECT 
    results.constructorId,
    AVG(NULLIF(CAST(results.position AS SIGNED), 0)) AS average_position,
    COUNT(constructor_results.constructorResultsId) AS total_races
FROM
    results
JOIN
    constructor_results ON results.constructorId = constructor_results.constructorId
WHERE
    results.position NOT IN ('DNF', 'DSQ') -- Exclude non-numeric values
GROUP BY
    results.constructorId
HAVING
    COUNT(results.RaceId) > 20
ORDER BY
    average_position DESC;


-- Who is the greatest driver of all time?
