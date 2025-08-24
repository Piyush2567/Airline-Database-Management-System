-- MySQL 8.0+ schema (close parity)
DROP DATABASE IF EXISTS airline_db;
CREATE DATABASE airline_db;
USE airline_db;

CREATE TABLE airports (
    airport_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    city            VARCHAR(100) NOT NULL,
    country         VARCHAR(100) NOT NULL,
    code            CHAR(3) UNIQUE NOT NULL
);

CREATE TABLE aircrafts (
    aircraft_id     BIGINT PRIMARY KEY AUTO_INCREMENT,
    model           VARCHAR(100) NOT NULL,
    capacity        INT NOT NULL CHECK (capacity > 0 AND capacity <= 600)
);

CREATE TABLE flights (
    flight_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    flight_number   VARCHAR(10) UNIQUE NOT NULL,
    origin_id       BIGINT NOT NULL,
    destination_id  BIGINT NOT NULL,
    departure_time  DATETIME NOT NULL,
    arrival_time    DATETIME NOT NULL,
    aircraft_id     BIGINT NOT NULL,
    status          VARCHAR(20) NOT NULL DEFAULT 'SCHEDULED' CHECK (status IN ('SCHEDULED','BOARDING','DEPARTED','ARRIVED','CANCELLED','DELAYED')),
    CONSTRAINT fk_f_origin FOREIGN KEY (origin_id) REFERENCES airports(airport_id),
    CONSTRAINT fk_f_dest FOREIGN KEY (destination_id) REFERENCES airports(airport_id),
    CONSTRAINT fk_f_air FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id)
);

CREATE TABLE passengers (
    passenger_id    BIGINT PRIMARY KEY AUTO_INCREMENT,
    first_name      VARCHAR(100) NOT NULL,
    last_name       VARCHAR(100) NOT NULL,
    passport_number VARCHAR(20) UNIQUE,
    nationality     VARCHAR(50)
);

CREATE TABLE bookings (
    booking_id      BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    passenger_id    BIGINT NOT NULL,
    flight_id       BIGINT NOT NULL,
    channel         VARCHAR(30) NOT NULL DEFAULT 'WEB',
    CONSTRAINT fk_b_p FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id) ON DELETE CASCADE,
    CONSTRAINT fk_b_f FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT uq_passenger_flight UNIQUE (passenger_id, flight_id)
);

CREATE TABLE tickets (
    ticket_id       BIGINT PRIMARY KEY AUTO_INCREMENT,
    booking_id      BIGINT NOT NULL,
    flight_id       BIGINT NOT NULL,
    seat_number     VARCHAR(5) NOT NULL,
    class           VARCHAR(10) NOT NULL DEFAULT 'ECONOMY',
    price           DECIMAL(10,2) NOT NULL,
    CONSTRAINT fk_t_b FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) ON DELETE CASCADE,
    CONSTRAINT fk_t_f FOREIGN KEY (flight_id) REFERENCES flights(flight_id) ON DELETE CASCADE,
    CONSTRAINT uq_seat_per_flight UNIQUE (flight_id, seat_number)
);

CREATE TABLE staff (
    staff_id        BIGINT PRIMARY KEY AUTO_INCREMENT,
    name            VARCHAR(100) NOT NULL,
    role            VARCHAR(50) NOT NULL,
    assigned_flight BIGINT,
    CONSTRAINT fk_s_f FOREIGN KEY (assigned_flight) REFERENCES flights(flight_id) ON DELETE SET NULL
);

CREATE INDEX idx_flights_times ON flights (departure_time, arrival_time);
CREATE INDEX idx_flights_origin_dest ON flights (origin_id, destination_id);
CREATE INDEX idx_bookings_passenger ON bookings (passenger_id);
CREATE INDEX idx_bookings_flight ON bookings (flight_id);
CREATE INDEX idx_tickets_booking ON tickets (booking_id);
CREATE INDEX idx_staff_assigned ON staff (assigned_flight);

-- Note: To fully enforce flight match and capacity limits, use stored procedures for inserts or add triggers.
