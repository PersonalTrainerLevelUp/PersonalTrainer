--changeset karl:view:ClientDetailsView
--comment: Client details view
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
--rollback DROP VIEW "ClientDetailsView";

--changeset karl:view:BillingDetailsView
--comment: Billing details view
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
--rollback DROP VIEW "BillingDetailsView";

--changeset karl:view:ProgramExercisesView
--comment: Program exercises view
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
--rollback DROP VIEW "ProgramExercisesView";