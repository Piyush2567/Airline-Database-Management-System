-- Performance analysis queries (PostgreSQL)

EXPLAIN ANALYZE
SELECT f.flight_number, a1.city AS origin, a2.city AS destination, f.departure_time
FROM flights f
JOIN airports a1 ON f.origin_id = a1.airport_id
JOIN airports a2 ON f.destination_id = a2.airport_id
WHERE a1.city = 'Delhi' AND a2.city = 'Mumbai';

EXPLAIN ANALYZE
SELECT f.flight_number, SUM(t.price) AS total_revenue
FROM flights f
JOIN bookings b ON f.flight_id = b.flight_id
JOIN tickets t ON b.booking_id = t.booking_id
GROUP BY f.flight_number;
