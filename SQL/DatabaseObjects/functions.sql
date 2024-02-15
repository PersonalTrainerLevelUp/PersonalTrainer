--changeset karl:function:scalar:CalculateTotalPayment
--comment: Scalar function for calculating total payment
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
--rollback DROP FUNCTION "CalculateTotalPayment";

--changeset karl:function:table:CalculateClientProgramDuration
--comment: Table-valued function for calculating client program duration
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
--rollback DROP FUNCTION "CalculateClientProgramDuration";



--changeset liam:function:table:GetUnpaidBills
--comment: Update variable name
CREATE OR REPLACE FUNCTION GetUnpaidBills()
RETURNS TABLE (
    firstName VARCHAR,
    lastName VARCHAR,
    clientEmail VARCHAR,
    amountStillOwed DECIMAL(6,2)
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
        payment_sum.total_payment AS amountStillOwed
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
--rollback DROP FUNCTION "GetUnpaidBills";