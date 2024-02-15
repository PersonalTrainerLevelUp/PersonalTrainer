--changeset karl:procedure:CreateClient runOnChange:true
--comment: Procedure for creating a client
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
--rollback DROP PROCEDURE "CreateClient";

--changeset karl:procedure:CreateClientBillingProgram runOnChange:true
--comment: Procedure for creating a client billing program
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
--rollback DROP PROCEDURE "CreateClientBillingProgram";

--changeset karl:procedure:UpdateClient runOnChange:true
--comment: Procedure for updating client details
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
--rollback DROP PROCEDURE "UpdateClient";