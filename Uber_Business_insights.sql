-- 1.Average ride duration and distance per city
 SELECT c.city_name, AVG(r.ride_duration), AVG(r.ride_distance)
 FROM uber_analytics.rides r
 JOIN uber_analytics.locations l ON r.start_location_id = l.location_id
 JOIN uber_analytics.cities c ON l.city_id = c.city_id
 GROUP BY c.city_name;

-- 2.Revenue generated per city
 SELECT c.city_name, SUM(r.fare)
 FROM uber_analytics.rides r
 JOIN uber_analytics.locations l ON r.start_location_id = l.location_id
 JOIN uber_analytics.cities c ON l.city_id = c.city_id
-- WHERE r.status = 'completed'
 GROUP BY c.city_name;

 -- 3.Peak times for rides in different locations
 SELECT l.location_name, d.hour, COUNT(*)
 FROM uber_analytics.rides r
 JOIN uber_analytics.locations l ON r.start_location_id = l.location_id
 JOIN uber_analytics.dates d ON r.ride_date_time = d.date_time
 GROUP BY l.location_name, d.hour
 ORDER BY COUNT(*) DESC;

 -- 4.Popular routes and destinations
 SELECT l1.location_name AS start_location, l2.location_name AS end_location, COUNT(*) AS number_of_rides
 FROM uber_analytics.rides r
 JOIN uber_analytics.locations l1 ON r.start_location_id = l1.location_id
 JOIN uber_analytics.locations l2 ON r.end_location_id = l2.location_id
 GROUP BY l1.location_name, l2.location_name
 ORDER BY number_of_rides DESC;

-- 5.Average rider rating per driver
 SELECT d.driver_name, AVG(r.rating_by_driver)
 FROM uber_analytics.rides r
 JOIN uber_analytics.drivers d ON r.driver_id = d.driver_id
 GROUP BY d.driver_name;

-- 6. Average driver rating per rider
 SELECT ri.rider_name, AVG(r.rating_by_rider)
 FROM uber_analytics.rides r
 JOIN uber_analytics.riders ri ON r.rider_id = ri.rider_id
 GROUP BY ri.rider_name;

-- 7. Time taken by a driver from ride acceptance to customer pickup
 SELECT d.driver_id, d.driver_name, r.ride_id, 
       TIMEDIFF(pickup_status.time, acceptance_status.time) AS time_to_pickup
 FROM uber_analytics.ride_status acceptance_status 
JOIN uber_analytics.ride_status pickup_status ON acceptance_status.ride_id = pickup_status.ride_id
 JOIN uber_analytics.rides r ON r.ride_id = acceptance_status.ride_id
 JOIN uber_analytics.drivers d ON r.driver_id = d.driver_id
 WHERE acceptance_status.status = 'accepted' 
AND pickup_status.status = 'started';

-- 8. Rate of ride cancellations by riders and drivers
 SELECT 
    (SELECT COUNT(DISTINCT ride_id) FROM uber_analytics.ride_status WHERE status = 'cancelled_by_driver') * 1.0 / 
    (SELECT COUNT(DISTINCT ride_id) FROM uber_analytics.rides) as driver_cancellation_rate,
    (SELECT COUNT(DISTINCT ride_id) FROM uber_analytics.ride_status WHERE status = 'cancelled_by_rider') * 1.0 / 
    (SELECT COUNT(DISTINCT ride_id) FROM uber_analytics.rides) as rider_cancellation_rate;

-- 9. Impact of weather on ride demand
 SELECT w.weather_condition, COUNT(*) AS number_of_rides
 FROM uber_analytics.rides r
 JOIN uber_analytics.locations l ON r.start_location_id = l.location_id
 JOIN uber_analytics.weather w ON l.city_id = w.city_id
 AND DATE_FORMAT(r.ride_date_time, '%Y-%m-%d %H:00:00') = w.date_time
 GROUP BY w.weather_condition;

-- 10. Rider loyalty metrics
 SELECT ri.rider_name, COUNT(*), AVG(r.fare), DATEDIFF(MAX(r.ride_date_time), ri.signup_date) as days_since_signup
 FROM uber_analytics.rides r
 JOIN uber_analytics.riders ri ON r.rider_id = ri.rider_id
 GROUP BY ri.rider_name;


 