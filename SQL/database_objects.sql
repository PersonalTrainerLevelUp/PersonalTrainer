
-- Views
CREATE OR REPLACE VIEW ClientDetailsView AS
SELECT DISTINCT ON (c.client_id)
    c.client_id,
    c.first_name,
    c.last_name,
    c.email,
    c.contact_number,
    c.date_of_birth,
    c.joined_date,
    p.program_name,
    cp.start_date AS program_start_date,
    cp.end_date AS program_end_date
FROM
    clients c
JOIN
    client_program cp ON c.client_id = cp.client_id
JOIN
    programs p ON cp.program_id = p.program_id
ORDER BY
    c.client_id,
    cp.start_date DESC;



CREATE OR REPLACE VIEW BillingDetailsView AS
SELECT
    b.billing_id,
    c.first_name,
	c.last_name,
	c.email,
    b.amount * DATE_PART('month', AGE(CURRENT_DATE, c.joined_date)) AS total_billed,
    COALESCE(SUM(p.amount), 0) AS amount_paid,
	(b.amount * DATE_PART('month', AGE(CURRENT_DATE, c.joined_date))) - (COALESCE(SUM(p.amount), 0)) AS amount_owed
FROM
    billing b
JOIN
    clients c ON b.client_id = c.client_id
LEFT JOIN
    payments p ON b.billing_id = p.billing_id
GROUP BY
    b.billing_id,
    c.first_name,
    c.last_name,
	c.email,
    b.amount,
    b.payment_due_date,
    p.payment_date,
    c.joined_date
ORDER BY
    b.billing_id;

CREATE OR REPLACE VIEW ProgramExercisesView AS
 SELECT p.program_name,
    e.exercise_name,
    e.exercise_type,
    e.exercise_description,
    pe.set_count,
    pe.rep_count,
    pe.rest_period_seconds
   FROM program_exercise pe
     JOIN exercises e ON pe.exercise_id = e.exercise_id
     JOIN programs p ON pe.program_id = p.program_id
  ORDER BY p.program_name;

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


CREATE OR REPLACE PROCEDURE CreateClientBillingProgram(
    IN p_first_name VARCHAR(255),
    IN p_last_name VARCHAR(255),
    IN p_email VARCHAR(255),
    IN p_contact_number VARCHAR(255),
    IN p_date_of_birth DATE,
    IN p_joined_date DATE,
    IN p_amount DECIMAL(6,2),
    IN p_program_id INTEGER
)
AS $$
DECLARE
    p_client_id INTEGER;
BEGIN

    INSERT INTO clients (first_name, last_name, email, contact_number, date_of_birth, joined_date)
    VALUES (p_first_name, p_last_name, p_email, p_contact_number, p_date_of_birth, p_joined_date)
    RETURNING client_id INTO p_client_id;

    INSERT INTO billing (client_id, amount, payment_due_date)
    VALUES (p_client_id, p_amount, p_joined_date + INTERVAL '1 month');

    INSERT INTO client_program (program_id, client_id, start_date, end_date)
    VALUES (p_program_id, p_client_id, p_joined_date, p_joined_date + INTERVAL '3 months');
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE UpdateClient(
    IN p_client_id INTEGER,
    IN new_first_name VARCHAR(255),
    IN new_last_name VARCHAR(255),
    IN new_email VARCHAR(255),
    IN new_contact_number VARCHAR(255)
)
AS $$
BEGIN
    UPDATE clients
    SET first_name = new_first_name,
        last_name = new_last_name,
        email = new_email,
        contact_number = new_contact_number
    WHERE client_id = p_client_id; 
END;
$$
LANGUAGE plpgsql;


-- Scalar Functions
CREATE OR REPLACE FUNCTION CalculateTotalPayment(
    client_id_param INTEGER
)
RETURNS DECIMAL
AS $$
DECLARE
    billing_id_param INTEGER;
    total_payment DECIMAL := 0;
BEGIN
    SELECT billing_id INTO billing_id_param FROM billing WHERE client_id = client_id_param;

    SELECT SUM(amount) INTO total_payment FROM payments WHERE billing_id = billing_id_param;

    RETURN total_payment;
END;
$$
LANGUAGE plpgsql;


-- Table-Valued Functions
CREATE OR REPLACE FUNCTION CalculateClientProgramDuration(
    client_id_param INTEGER
)
RETURNS TABLE (
    program_id_result INTEGER,
    duration_days INTEGER
)
AS $$
BEGIN
    RETURN QUERY SELECT cp.program_id AS program_id_result, 
                         EXTRACT(DAY FROM AGE(cp.end_date, cp.start_date))::INTEGER AS duration_days 
                 FROM client_program cp
                 WHERE cp.client_id = client_id_param;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION GetUnpaidBills()
RETURNS TABLE (
    firstName VARCHAR,
    lastName VARCHAR,
    clientEmail VARCHAR,
    amountStillOwe DECIMAL(6,2)
)
AS $$
DECLARE
    months_with_client INTEGER;
BEGIN
    RETURN QUERY 
    SELECT 
        c.first_name AS firstName,
        c.last_name AS lastName,
        c.email AS clientEmail,
        payment_sum.total_payment AS amountStillOwe
    FROM 
        billing b
    JOIN
        clients c ON b.client_id = c.client_id
    LEFT JOIN
        (
            SELECT 
                client_id,
                date_part('month', AGE(CURRENT_DATE, joined_date)) AS months_with_client
            FROM 
                clients
        ) AS months ON c.client_id = months.client_id
    LEFT JOIN
        (
            SELECT 
                billing_id,
                SUM(amount) AS total_payment
            FROM 
                payments
            GROUP BY 
                billing_id
        ) AS payment_sum ON b.billing_id = payment_sum.billing_id
    WHERE 
         payment_sum.total_payment < (b.amount * months.months_with_client);
END;
$$
LANGUAGE plpgsql;
