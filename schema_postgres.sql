-- PostgreSQL schema (primary dialect)
-- Drop & recreate schema for clean runs
DROP SCHEMA IF EXISTS airline CASCADE;
CREATE SCHEMA airline;
SET search_path = airline;

-- Airports
CREATE TABLE airports (
    airport_id      BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    country         VARCHAR(100) NOT NULL,
    code            CHAR(3) UNIQUE NOT NULL
);

-- Aircrafts
CREATE TABLE aircrafts (
    aircraft_id     BIGSERIAL PRIMARY KEY,
    model           VARCHAR(100) NOT NULL,
    capacity        INT NOT NULL CHECK (capacity > 0 AND capacity <= 600)
);

-- Flights
CREATE TABLE flights (
    flight_id       BIGSERIAL PRIMARY KEY,
    flight_number   VARCHAR(10) UNIQUE NOT NULL,
    origin_id       BIGINT NOT NULL REFERENCES airports(airport_id) ON DELETE RESTRICT,
    destination_id  BIGINT NOT NULL REFERENCES airports(airport_id) ON DELETE RESTRICT,
    departure_time  TIMESTAMP NOT NULL,
    arrival_time    TIMESTAMP NOT NULL,
    aircraft_id     BIGINT NOT NULL REFERENCES aircrafts(aircraft_id) ON DELETE RESTRICT,
    status          VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED','BOARDING','DEPARTED','ARRIVED','CANCELLED','DELAYED'))
);

-- Passengers
CREATE TABLE passengers (
    passenger_id    BIGSERIAL PRIMARY KEY,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    passport_number VARCHAR(20) UNIQUE,
    nationality     VARCHAR(50)
);

-- Bookings
CREATE TABLE bookings (
    booking_id      BIGSERIAL PRIMARY KEY,
    booking_date    TIMESTAMP NOT NULL DEFAULT NOW(),
    passenger_id    BIGINT NOT NULL REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    flight_id       BIGINT NOT NULL REFERENCES flights(flight_id) ON DELETE CASCADE,
    channel         VARCHAR(30) NOT NULL DEFAULT 'WEB' CHECK (channel IN ('WEB','MOBILE','AGENT','COUNTER')),
    CONSTRAINT uq_passenger_flight UNIQUE (passenger_id, flight_id)
);

-- Tickets
-- Note: We include flight_id for indexing seat uniqueness; a trigger will enforce that it matches bookings.flight_id
CREATE TABLE tickets (
    ticket_id       BIGSERIAL PRIMARY KEY,
    booking_id      BIGINT NOT NULL REFERENCES bookings(booking_id) ON DELETE CASCADE,
    flight_id       BIGINT NOT NULL REFERENCES flights(flight_id) ON DELETE CASCADE,
    seat_number     VARCHAR(5) NOT NULL,
    class           VARCHAR(10) NOT NULL DEFAULT 'ECONOMY' CHECK (class IN ('ECONOMY','PREMIUM','BUSINESS','FIRST')),
    price           NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    CONSTRAINT uq_seat_per_flight UNIQUE (flight_id, seat_number)
);

-- Staff
CREATE TABLE staff (
    staff_id        BIGSERIAL PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    role            VARCHAR(50) NOT NULL CHECK (role IN ('PILOT','COPILOT','FLIGHT_ATTENDANT','GROUND')),
    assigned_flight BIGINT REFERENCES flights(flight_id) ON DELETE SET NULL
);

-- Helpful indexes for joins & filters
CREATE INDEX idx_flights_times ON flights (departure_time, arrival_time);
CREATE INDEX idx_flights_origin_dest ON flights (origin_id, destination_id);
CREATE INDEX idx_bookings_passenger ON bookings (passenger_id);
CREATE INDEX idx_bookings_flight ON bookings (flight_id);
CREATE INDEX idx_tickets_booking ON tickets (booking_id);
CREATE INDEX idx_staff_assigned ON staff (assigned_flight);

-- Views
CREATE VIEW v_flight_manifest AS
SELECT f.flight_number, p.passenger_id, p.first_name, p.last_name, t.seat_number, t.class
FROM tickets t
JOIN bookings b ON t.booking_id = b.booking_id
JOIN passengers p ON b.passenger_id = p.passenger_id
JOIN flights f ON b.flight_id = f.flight_id
ORDER BY f.flight_number, t.seat_number;

CREATE VIEW v_flight_revenue AS
SELECT f.flight_number, SUM(t.price) AS total_revenue, COUNT(*) AS tickets_sold
FROM tickets t
JOIN flights f ON t.flight_id = f.flight_id
GROUP BY f.flight_number
ORDER BY total_revenue DESC;

COMMENT ON VIEW v_flight_manifest IS 'Passenger list per flight with seats and cabin class';
COMMENT ON VIEW v_flight_revenue  IS 'Aggregated revenue and ticket count per flight';
