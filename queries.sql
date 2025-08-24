-- Example operational & analytical queries
SET search_path = airline; -- (PostgreSQL; harmless in MySQL)

-- 1) List flights between two cities with times
-- Indexes used: idx_flights_origin_dest, idx_flights_times
SELECT f.flight_number, a1.city AS origin, a2.city AS destination, f.departure_time, f.arrival_time
FROM flights f
JOIN airports a1 ON f.origin_id = a1.airport_id
JOIN airports a2 ON f.destination_id = a2.airport_id
WHERE a1.city = 'Delhi' AND a2.city = 'Mumbai'
ORDER BY f.departure_time;

-- 2) Find all passengers on a specific flight with seat numbers
SELECT f.flight_number, p.first_name, p.last_name, t.seat_number, t.class
FROM tickets t
JOIN bookings b ON t.booking_id = b.booking_id
JOIN passengers p ON b.passenger_id = p.passenger_id
JOIN flights f ON t.flight_id = f.flight_id
WHERE f.flight_number = 'AI101'
ORDER BY t.seat_number;

-- 3) Revenue per flight (uses view as well)
SELECT * FROM v_flight_revenue;

-- 4) Crew roster per flight
SELECT f.flight_number, s.name, s.role
FROM staff s
JOIN flights f ON s.assigned_flight = f.flight_id
ORDER BY f.flight_number, s.role;

-- 5) Load factor approximation (tickets sold / aircraft capacity)
SELECT f.flight_number,
       COUNT(t.ticket_id)::DECIMAL / a.capacity AS load_factor
FROM flights f
JOIN aircrafts a ON f.aircraft_id = a.aircraft_id
LEFT JOIN tickets t ON t.flight_id = f.flight_id
GROUP BY f.flight_number, a.capacity;

-- 6) Top routes by revenue
SELECT a1.code AS origin, a2.code AS destination, SUM(t.price) AS revenue
FROM tickets t
JOIN flights f ON t.flight_id = f.flight_id
JOIN airports a1 ON f.origin_id = a1.airport_id
JOIN airports a2 ON f.destination_id = a2.airport_id
GROUP BY a1.code, a2.code
ORDER BY revenue DESC;

-- 7) Book a ticket safely (PostgreSQL)
-- SELECT book_ticket_safe(1, 1, '14C', 'ECONOMY', 4500.00);

-- 8) Cancel a booking (cascades to tickets)
-- DELETE FROM bookings WHERE booking_id = 1;

-- 9) Update flight status
UPDATE flights SET status = 'DELAYED' WHERE flight_number = 'AI101';

-- 10) Manifest view usage
SELECT * FROM v_flight_manifest WHERE flight_number = 'AI101';
