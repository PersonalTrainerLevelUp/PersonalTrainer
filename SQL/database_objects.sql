
-- Views
CREATE OR REPLACE VIEW ClientDetailsView AS
SELECT
    c.client_id,
    c.first_name,
    c.last_name,
    c.email,
    c.contact_number,
    c.date_of_birth,
    c.joined_date,
    cp.program_id,
    p.program_name,
    cp.start_date,
    cp.end_date
FROM
    clients c
JOIN
    client_program cp ON c.client_id = cp.client_id
JOIN
    programs p ON cp.program_id = p.program_id;

CREATE OR REPLACE VIEW BillingDetailsView AS
SELECT
    b.billing_id,
    b.client_id,
    b.amount,
    b.payment_due_date,
    p.payment_id,
    p.amount AS payment_amount,
    p.payment_date
FROM
    billing b
LEFT JOIN
    payments p ON b.billing_id = p.billing_id;

CREATE OR REPLACE VIEW ProgramExercisesView AS
SELECT
    pe.program_id,
    pe.exercise_id,
    e.exercise_name,
    e.exercise_type,
    e.exercise_description,
    pe.set_count,
    pe.rep_count,
    pe.rest_period_seconds
FROM
    program_exercise pe
JOIN
    exercises e ON pe.exercise_id = e.exercise_id;

-- Stored Procedures
CREATE OR REPLACE PROCEDURE CreateClient(
    IN first_name VARCHAR(255),
    IN last_name VARCHAR(255),
    IN email VARCHAR(255),
    IN contact_number VARCHAR(255),
    IN date_of_birth DATE,
    IN joined_date DATE
)
AS $$
BEGIN
    INSERT INTO clients (first_name, last_name, email, contact_number, date_of_birth, joined_date)
    VALUES (first_name, last_name, email, contact_number, date_of_birth, joined_date);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE UpdateClient(
    IN client_id INTEGER,
    IN new_first_name VARCHAR(255),
    IN new_last_name VARCHAR(255),
    IN new_email VARCHAR(255),
    IN new_contact_number VARCHAR(255),
    IN new_date_of_birth DATE,
    IN new_joined_date DATE
)
AS $$
BEGIN
    UPDATE clients
    SET first_name = new_first_name,
        last_name = new_last_name,
        email = new_email,
        contact_number = new_contact_number,
        date_of_birth = new_date_of_birth,
        joined_date = new_joined_date
    WHERE client_id = client_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE GenerateBill(
    IN client_id INTEGER,
    IN amount DECIMAL(6,2),
    IN payment_due_date DATE
)
AS $$
BEGIN
    INSERT INTO billing (client_id, amount, payment_due_date)
    VALUES (client_id, amount, payment_due_date);
END;
$$
LANGUAGE plpgsql;

-- Scalar Functions
CREATE OR REPLACE FUNCTION CalculateTotalPayment(
    billing_id INTEGER
)
RETURNS DECIMAL
AS $$
DECLARE
    total_payment DECIMAL;
BEGIN
    SELECT SUM(amount) INTO total_payment FROM payments WHERE billing_id = billing_id;
    RETURN total_payment;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION CalculateProgramDuration(
    program_id INTEGER
)
RETURNS INTEGER
AS $$
DECLARE
    duration INTEGER;
BEGIN
    SELECT EXTRACT(DAY FROM (end_date - start_date)) INTO duration FROM client_program WHERE program_id = program_id;
    RETURN duration;
END;
$$
LANGUAGE plpgsql;

-- Table-Valued Functions
CREATE OR REPLACE FUNCTION GetClientPrograms(
    client_id INTEGER
)
RETURNS TABLE (
    program_id INTEGER,
    program_name VARCHAR(255),
    start_date DATE,
    end_date DATE
)
AS $$
BEGIN
    RETURN QUERY SELECT program_id, program_name, start_date, end_date FROM client_program WHERE client_id = client_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION GetUnpaidBills()
RETURNS TABLE (
    billing_id INTEGER,
    client_id INTEGER,
    amount DECIMAL(6,2),
    payment_due_date DATE
)
AS $$
BEGIN
    RETURN QUERY SELECT billing_id, client_id, amount, payment_due_date FROM billing WHERE payment_due_date < CURRENT_DATE AND billing_id NOT IN (SELECT DISTINCT billing_id FROM payments);
END;
$$
LANGUAGE plpgsql;
