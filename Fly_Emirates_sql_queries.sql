SELECT COUNT(*) FROM airlines;

SELECT COUNT(*) FROM airports;

SELECT COUNT(*) FROM flights;

-- Check Missing Values
SELECT
COUNT(*) total_rows,
SUM(CASE WHEN tail_number IS NULL THEN 1 ELSE 0 END) AS tail_number_nulls,
SUM(CASE WHEN departure_delay IS NULL THEN 1 ELSE 0 END) AS departure_delay_nulls,
SUM(CASE WHEN arrival_delay IS NULL THEN 1 ELSE 0 END) AS arrival_delay_nulls,
SUM(CASE WHEN cancellation_reason IS NULL THEN 1 ELSE 0 END) AS cancellation_reason_nulls
FROM flight_analysis;

-- Create Flight Date
ALTER TABLE flight_analysis
ADD COLUMN flight_date DATE;

UPDATE flight_analysis
SET flight_date =
STR_TO_DATE(
CONCAT(year,'-',month,'-',day),
'%Y-%m-%d'
);

-- Create Cancellation Description
ALTER TABLE flight_analysis
ADD COLUMN cancellation_reason_desc VARCHAR(50);

UPDATE flight_analysis
SET cancellation_reason_desc =
CASE cancellation_reason
    WHEN 'A' THEN 'Airline/Carrier'
    WHEN 'B' THEN 'Weather'
    WHEN 'C' THEN 'National Air System'
    WHEN 'D' THEN 'Security'
    ELSE 'Not Cancelled'
END;

-- Total Flights
SELECT COUNT(*) AS total_flights
FROM flight_analysis;

-- Total Cancelled Flights
SELECT COUNT(*) AS cancelled_flights
FROM flight_analysis
WHERE cancelled = 1;

-- Cancellation Rate
SELECT
    ROUND(
        100 * SUM(cancelled) / COUNT(*),
        2
    ) AS cancellation_rate
FROM flight_analysis;

-- Diversion Rate
SELECT
ROUND(
100 * SUM(diverted) / COUNT(*),
2
) AS diversion_rate
FROM flight_analysis;

-- Average Departure Delay
SELECT
ROUND(AVG(departure_delay),2) AS avg_departure_delay
FROM flight_analysis
WHERE departure_delay IS NOT NULL;

-- Average Arrival Delay
SELECT
ROUND(AVG(arrival_delay),2) AS avg_arrival_delay
FROM flight_analysis
WHERE arrival_delay IS NOT NULL;

-- Most Important Airline Analysis
SELECT
airline_name,
COUNT(*) AS total_flights,
ROUND(AVG(arrival_delay),2) AS avg_arrival_delay
FROM flight_analysis
GROUP BY airline_name
ORDER BY avg_arrival_delay;

-- Most Important Delay Cause Analysis
SELECT
ROUND(AVG(airline_delay),2) AS airline_delay,
ROUND(AVG(weather_delay),2) AS weather_delay,
ROUND(AVG(air_system_delay),2) AS air_system_delay,
ROUND(AVG(security_delay),2) AS security_delay,
ROUND(AVG(late_aircraft_delay),2) AS late_aircraft_delay
FROM flight_analysis;

-- Flights by Month
SELECT
    month,
    COUNT(*) AS total_flights
FROM flight_analysis
GROUP BY month
ORDER BY month;

-- Flights by Day of Week
SELECT
    day_of_week,
    COUNT(*) AS total_flights
FROM flight_analysis
GROUP BY day_of_week
ORDER BY day_of_week;

-- Top 10 Busiest Airports
SELECT
    origin_airport_name,
    COUNT(*) AS total_departures
FROM flight_analysis
GROUP BY origin_airport_name
ORDER BY total_departures DESC
LIMIT 10;

-- Top 10 Airports with Highest Arrival Delay
SELECT
    destination_airport_name,
    ROUND(AVG(arrival_delay),2) AS avg_arrival_delay
FROM flight_analysis
WHERE arrival_delay IS NOT NULL
GROUP BY destination_airport_name
ORDER BY avg_arrival_delay DESC
LIMIT 10;

-- Cancellation Reasons
SELECT
    cancellation_reason_desc,
    COUNT(*) AS total_cancellations
FROM flight_analysis
WHERE cancelled = 1
GROUP BY cancellation_reason_desc
ORDER BY total_cancellations DESC;

-- Monthly Cancellation Trend
SELECT
    month,
    COUNT(*) AS cancelled_flights
FROM flight_analysis
WHERE cancelled = 1
GROUP BY month
ORDER BY month;

-- Best Airlines (Lowest Arrival Delay)
SELECT
    airline_name,
    ROUND(AVG(arrival_delay),2) AS avg_arrival_delay
FROM flight_analysis
WHERE arrival_delay IS NOT NULL
GROUP BY airline_name
ORDER BY avg_arrival_delay
LIMIT 10;

-- Worst Airlines (Highest Arrival Delay)
SELECT
    airline_name,
    ROUND(AVG(arrival_delay),2) AS avg_arrival_delay
FROM flight_analysis
WHERE arrival_delay IS NOT NULL
GROUP BY airline_name
ORDER BY avg_arrival_delay DESC
LIMIT 10;
