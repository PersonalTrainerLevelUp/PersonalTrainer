--changeset karl:ddl:createTable:clients
--comment: Create clients table
CREATE TABLE "clients" (
  "client_id" serial PRIMARY KEY NOT NULL,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) NOT NULL,
  "contact_number" varchar(255),
  "date_of_birth" date NOT NULL,
  "joined_date" date NOT NULL
);
--rollback DROP TABLE "clients";

--changeset karl:ddl:createTable:programs
--comment: Create programs table
CREATE TABLE "programs" (
  "program_id" serial PRIMARY KEY NOT NULL,
  "program_name" varchar(255) NOT NULL,
  "difficulty_id" integer NOT NULL,
  "program_description" varchar(255)
);
--rollback DROP TABLE "programs";

--changeset karl:ddl:createTable:exercises
--comment: Create exercises table
CREATE TABLE "exercises" (
  "exercise_id" serial PRIMARY KEY NOT NULL,
  "exercise_name" varchar(255) NOT NULL,
  "exercise_type" varchar(255) NOT NULL,
  "exercise_description" varchar(255)
);
--rollback DROP TABLE "exercises";

--changeset karl:ddl:createTable:client_program
--comment: Create client_program table
CREATE TABLE "client_program" (
  "id" serial PRIMARY KEY NOT NULL,
  "program_id" integer NOT NULL,
  "client_id" integer NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date
);
--rollback DROP TABLE "client_program";

--changeset karl:ddl:createTable:program_exercise
--comment: Create program_exercise table
CREATE TABLE "program_exercise" (
  "id" serial PRIMARY KEY NOT NULL,
  "exercise_id" integer NOT NULL,
  "program_id" integer NOT NULL,
  "set_count" integer NOT NULL,
  "rep_count" integer NOT NULL,
  "rest_period_seconds" integer NOT NULL
);
--rollback DROP TABLE "program_exercise";

--changeset karl:ddl:createTable:billing
--comment: Create billing table 
CREATE TABLE "billing" (
  "billing_id" serial PRIMARY KEY NOT NULL,
  "client_id" integer NOT NULL,
  "amount" decimal(6,2) NOT NULL,
  "payment_due_date" date NOT NULL
);
--rollback DROP TABLE "billing";

--changeset karl:ddl:createTable:payments
--comment: Create payments table
CREATE TABLE "payments" (
  "payment_id" serial PRIMARY KEY NOT NULL,
  "amount" decimal(6,2) NOT NULL,
  "billing_id" integer NOT NULL,
  "payment_date" date NOT NULL
);
--rollback DROP TABLE "payments";

--changeset karl:ddl:createTable:difficulty
--comment: Create difficulty table
CREATE TABLE "difficulty" (
  "difficulty_id" serial PRIMARY KEY NOT NULL,
  "difficulty_description" varchar(255) NOT NULL,
  "years_experience" integer NOT NULL
);
--rollback DROP TABLE "difficulty";
