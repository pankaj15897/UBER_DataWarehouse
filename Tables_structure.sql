-- Dimension Tables
CREATE TABLE `uber_analytics.cities` (
  city_id STRING NOT NULL,
  city_name STRING,
  state STRING,
  country STRING
);

CREATE TABLE `uber_analytics.locations` (
  location_id STRING NOT NULL,
  city_id STRING NOT NULL,
  location_name STRING,
  latitude FLOAT64,
  longitude FLOAT64
);

CREATE TABLE `uber_analytics.drivers` (
  driver_id STRING NOT NULL,
  driver_name STRING,
  driver_phone_number STRING,
  driver_email STRING,
  signup_date DATE,
  vehicle_type STRING,
  driver_city_id STRING NOT NULL
);

CREATE TABLE `uber_analytics.riders` (
  rider_id STRING NOT NULL,
  rider_name STRING,
  rider_phone_number STRING,
  rider_email STRING,
  signup_date DATE,
  loyalty_status STRING,
  rider_city_id STRING NOT NULL
);

CREATE TABLE `uber_analytics.dates` (
  date_time TIMESTAMP NOT NULL,
  day INT64,
  month INT64,
  year INT64,
  weekday STRING
);

CREATE TABLE `uber_analytics.weather` (
  weather_id STRING NOT NULL,
  city_id STRING NOT NULL,
  date_time TIMESTAMP NOT NULL,
  weather_condition STRING,
  temperature FLOAT64
);

CREATE TABLE `uber_analytics.dates` (
  date_time TIMESTAMP NOT NULL,
  date DATE,
  day INT64,
  month INT64,
  year INT64,
  quarter INT64,
  weekday STRING,
  hour INT64,
  is_weekend BOOL,
  --PRIMARY KEY (date_time)
);

-- Fact Tables
CREATE TABLE `uber_analytics.rides` (
  ride_id STRING NOT NULL,
  driver_id STRING NOT NULL,
  rider_id STRING NOT NULL,
  start_location_id STRING NOT NULL,
  end_location_id STRING NOT NULL,
  ride_date_time TIMESTAMP NOT NULL,
  ride_duration FLOAT64,
  ride_distance FLOAT64,
  fare FLOAT64,
  rating_by_driver FLOAT64,
  rating_by_rider FLOAT64
) PARTITION BY TIMESTAMP_TRUNC(ride_date_time, DAY);

CREATE TABLE `uber_analytics.ride_status` (
  status_id STRING NOT NULL,
  ride_id STRING NOT NULL,
  status STRING,
  status_time TIMESTAMP NOT NULL
) PARTITION BY TIMESTAMP_TRUNC(status_time, HOUR);