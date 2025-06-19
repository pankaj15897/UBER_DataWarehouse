import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
import random
from google.cloud import bigquery

fake = Faker()
client = bigquery.Client()

# Generate Cities
def generate_cities(n=50):
    return pd.DataFrame([{
        'city_id': f"city_{i}",
        'city_name': fake.city(),
        'state': fake.state(),
        'country': fake.country()
    } for i in range(n)])

# Generate Locations
def generate_locations(cities_df, locations_per_city=20):
    locations = []
    for _, city in cities_df.iterrows():
        for _ in range(locations_per_city):
            locations.append({
                'location_id': fake.uuid4(),
                'city_id': city['city_id'],
                'location_name': fake.street_name(),
                'latitude': float(fake.latitude()),
                'longitude': float(fake.longitude())
            })
    return pd.DataFrame(locations)

# Generate Drivers
def generate_drivers(cities_df, n=1000):
    return pd.DataFrame([{
        'driver_id': f"driver_{i}",
        'driver_name': fake.name(),
        'driver_phone_number': fake.phone_number(),
        'driver_email': fake.email(),
        'signup_date': fake.date_between('-2y'),
        'vehicle_type': random.choice(['Sedan', 'SUV', 'Luxury']),
        'driver_city_id': random.choice(cities_df['city_id'])
    } for i in range(n)])

# Generate Riders
def generate_riders(cities_df, n=5000):
    return pd.DataFrame([{
        'rider_id': f"rider_{i}",
        'rider_name': fake.name(),
        'rider_phone_number': fake.phone_number(),
        'rider_email': fake.email(),
        'signup_date': fake.date_between('-1y'),
        'loyalty_status': random.choice(['Bronze', 'Silver', 'Gold', 'Platinum']),
        'rider_city_id': random.choice(cities_df['city_id'])
    } for i in range(n)])

# Generate Rides
def generate_rides(drivers_df, riders_df, locations_df, n=100000):
    rides = []
    for _ in range(n):
        pickup_time = fake.date_time_between('-90d')
        duration = random.randint(5, 120)
        distance = random.uniform(0.5, 50)
        
        rides.append({
            'ride_id': fake.uuid4(),
            'driver_id': random.choice(drivers_df['driver_id']),
            'rider_id': random.choice(riders_df['rider_id']),
            'start_location_id': random.choice(locations_df['location_id']),
            'end_location_id': random.choice(locations_df['location_id']),
            'ride_date_time': pickup_time,
            'ride_duration': duration,
            'ride_distance': distance,
            'fare': round(distance * random.uniform(1.5, 3.5), 2),
            'rating_by_driver': random.randint(1, 5),
            'rating_by_rider': random.randint(1, 5)
        })
    return pd.DataFrame(rides)

# Generate Ride Status Events
def generate_ride_status(rides_df):
    status_events = []
    status_flow = ['requested', 'accepted', 'started', 'completed']
    
    for _, ride in rides_df.iterrows():
        base_time = ride['ride_date_time']
        for i, status in enumerate(status_flow):
            status_events.append({
                'status_id': fake.uuid4(),
                'ride_id': ride['ride_id'],
                'status': status,
                'status_time': base_time + timedelta(minutes=i*5)
            })
    return pd.DataFrame(status_events)

def generate_dates(start_date='2023-01-01', end_date='2024-12-31'):
    """Generate date dimension table with hourly granularity"""
    dates = []
    current = pd.Timestamp(start_date)
    end = pd.Timestamp(end_date)
    
    while current <= end:
        for hour in range(24):
            date_time = current + pd.Timedelta(hours=hour)
            dates.append({
                "date_time": date_time,
                "date": date_time.date(),
                "day": date_time.day,
                "month": date_time.month,
                "year": date_time.year,
                "quarter": (date_time.month-1)//3 + 1,
                "weekday": date_time.strftime('%A'),
                "hour": date_time.hour,
                "is_weekend": date_time.weekday() >= 5
            })
        current += pd.Timedelta(days=1)
    
    return pd.DataFrame(dates)


# Load to BigQuery
def load_to_bq(df, table_name):
    job = client.load_table_from_dataframe(
        df, f"uber_analytics.{table_name}"
    )
    job.result()
    print(f"Loaded {len(df)} rows to {table_name}")

# Pipeline Execution
if __name__ == "__main__":
    cities_df = generate_cities()
    locations_df = generate_locations(cities_df)
    drivers_df = generate_drivers(cities_df)
    riders_df = generate_riders(cities_df)
    rides_df = generate_rides(drivers_df, riders_df, locations_df)
    status_df = generate_ride_status(rides_df)
    dates_df = generate_dates()

    load_to_bq(cities_df, "cities")
    load_to_bq(locations_df, "locations")
    load_to_bq(drivers_df, "drivers")
    load_to_bq(riders_df, "riders")
    load_to_bq(rides_df, "rides")
    load_to_bq(status_df, "ride_status")
    load_to_bq(dates_df, "dates")