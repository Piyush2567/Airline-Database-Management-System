-- Sample data for both PostgreSQL and MySQL (adjust timestamps as needed)
-- Airports
INSERT INTO airports (name, city, country, code) VALUES
('Indira Gandhi International Airport', 'Delhi', 'India', 'DEL'),
('Chhatrapati Shivaji Maharaj International Airport', 'Mumbai', 'India', 'BOM'),
('Kempegowda International Airport', 'Bengaluru', 'India', 'BLR'),
('Netaji Subhas Chandra Bose International Airport', 'Kolkata', 'India', 'CCU'),
('Rajiv Gandhi International Airport', 'Hyderabad', 'India', 'HYD'),
('Dubai International Airport', 'Dubai', 'UAE', 'DXB');

-- Aircrafts
INSERT INTO aircrafts (model, capacity) VALUES
('Airbus A320neo', 180),
('Boeing 737 MAX 8', 178),
('Boeing 787-9', 290);

-- Flights
INSERT INTO flights (flight_number, origin_id, destination_id, departure_time, arrival_time, aircraft_id, status) VALUES
('AI101', 1, 2, '2025-04-10 07:30:00', '2025-04-10 09:30:00', 1, 'SCHEDULED'),
('AI202', 2, 1, '2025-04-10 18:45:00', '2025-04-10 20:45:00', 1, 'SCHEDULED'),
('AI303', 1, 6, '2025-04-12 22:15:00', '2025-04-13 00:45:00', 3, 'SCHEDULED'),
('AI404', 3, 2, '2025-04-11 06:00:00', '2025-04-11 08:00:00', 2, 'SCHEDULED');

-- Passengers
INSERT INTO passengers (first_name, last_name, passport_number, nationality) VALUES
('Aarav', 'Sharma', 'P1234567', 'Indian'),
('Diya', 'Mehta', 'P2345678', 'Indian'),
('Kabir', 'Singh', 'P3456789', 'Indian'),
('Fatima', 'Khan', 'P4567890', 'Indian');

-- Bookings (one per passenger per flight)
INSERT INTO bookings (booking_date, passenger_id, flight_id, channel) VALUES
('2025-04-01 10:00:00', 1, 1, 'WEB'),
('2025-04-01 11:00:00', 2, 1, 'MOBILE'),
('2025-04-02 12:30:00', 3, 3, 'AGENT'),
('2025-04-03 09:15:00', 4, 4, 'WEB');

-- Tickets
-- Note: For PostgreSQL, triggers will enforce capacity & flight match
INSERT INTO tickets (booking_id, flight_id, seat_number, class, price) VALUES
(1, 1, '12A', 'ECONOMY', 4500.00),
(2, 1, '12B', 'ECONOMY', 4500.00),
(3, 3, '3A',  'BUSINESS', 65000.00),
(4, 4, '20C', 'ECONOMY', 4000.00);

-- Staff
INSERT INTO staff (name, role, assigned_flight) VALUES
('Captain R. Iyer', 'PILOT', 1),
('First Officer S. Rao', 'COPILOT', 1),
('A. Kapoor', 'FLIGHT_ATTENDANT', 1),
('J. Thomas', 'GROUND', NULL);
