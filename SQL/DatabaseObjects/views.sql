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
SELECT b.billing_id,
       c.first_name,
       c.last_name,
       c.email,
       b.amount::double precision * date_part('month'::text, age(CURRENT_DATE::timestamp with time zone, c.joined_date::timestamp with time zone)) AS total_billed,
       COALESCE(p.amount_paid, 0::numeric) AS amount_paid,
       b.amount::double precision * date_part('month'::text, age(CURRENT_DATE::timestamp with time zone, c.joined_date::timestamp with time zone)) - COALESCE(p.amount_paid, 0::numeric)::double precision AS amount_owed
FROM billing b
JOIN clients c ON b.client_id = c.client_id
LEFT JOIN (
    SELECT billing_id,
           COALESCE(SUM(amount), 0) AS amount_paid
    FROM payments
    GROUP BY billing_id
) p ON b.billing_id = p.billing_id
GROUP BY b.billing_id, c.first_name, c.last_name, c.email, b.amount, b.payment_due_date, c.joined_date, p.amount_paid
ORDER BY b.billing_id;
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