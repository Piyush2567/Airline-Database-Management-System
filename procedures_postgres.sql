-- PostgreSQL procedures, triggers, and safety checks
SET search_path = airline;

-- Trigger to ensure tickets.flight_id equals the related bookings.flight_id
CREATE OR REPLACE FUNCTION trg_tickets_flight_match()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM 1 FROM bookings b WHERE b.booking_id = NEW.booking_id AND b.flight_id = NEW.flight_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Ticket flight_id must match booking''s flight_id';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_tickets_flight_match
BEFORE INSERT OR UPDATE ON tickets
FOR EACH ROW EXECUTE FUNCTION trg_tickets_flight_match();

-- Capacity enforcement: prevent selling seats beyond aircraft capacity
CREATE OR REPLACE FUNCTION trg_enforce_capacity()
RETURNS TRIGGER AS $$
DECLARE
    cap INT;
    sold INT;
BEGIN
    SELECT a.capacity INTO cap
    FROM flights f JOIN aircrafts a ON f.aircraft_id = a.aircraft_id
    WHERE f.flight_id = NEW.flight_id;

    SELECT COUNT(*) INTO sold FROM tickets WHERE flight_id = NEW.flight_id
    AND (TG_OP = 'UPDATE' AND ticket_id <> NEW.ticket_id OR TG_OP = 'INSERT');

    IF sold >= cap THEN
        RAISE EXCEPTION 'Cannot allocate more seats: capacity % reached', cap;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER t_enforce_capacity
BEFORE INSERT OR UPDATE ON tickets
FOR EACH ROW EXECUTE FUNCTION trg_enforce_capacity();

-- Safe booking function that creates booking + ticket atomically
CREATE OR REPLACE FUNCTION book_ticket_safe(
    p_passenger_id BIGINT,
    p_flight_id BIGINT,
    p_seat VARCHAR(5),
    p_class VARCHAR(10),
    p_price NUMERIC
) RETURNS BIGINT AS $$
DECLARE
    v_booking_id BIGINT;
BEGIN
    -- Create or reuse booking for passenger+flight
    INSERT INTO bookings (passenger_id, flight_id)
    VALUES (p_passenger_id, p_flight_id)
    ON CONFLICT (passenger_id, flight_id) DO UPDATE
        SET booking_date = NOW()
    RETURNING booking_id INTO v_booking_id;

    -- Create ticket; triggers enforce seat uniqueness and capacity
    INSERT INTO tickets (booking_id, flight_id, seat_number, class, price)
    VALUES (v_booking_id, p_flight_id, p_seat, p_class, p_price);

    RETURN v_booking_id;
END;
$$ LANGUAGE plpgsql;
