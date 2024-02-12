CREATE TABLE "clients" (
  "client_id" serial PRIMARY KEY NOT NULL,
  "first_name" varchar(255) NOT NULL,
  "last_name" varchar(255) NOT NULL,
  "email" varchar(255) NOT NULL,
  "contact_number" varchar(255),
  "date_of_birth" date NOT NULL,
  "joined_date" date NOT NULL
);

CREATE TABLE "programs" (
  "program_id" serial PRIMARY KEY NOT NULL,
  "program_name" varchar(255) NOT NULL,
  "difficulty_id" integer NOT NULL,
  "program_description" varchar(255)
);

CREATE TABLE "exercises" (
  "exercise_id" serial PRIMARY KEY NOT NULL,
  "exercise_name" varchar(255) NOT NULL,
  "exercise_type" varchar(255) NOT NULL,
  "exercise_description" varchar(255)
);

CREATE TABLE "client_program" (
  "id" serial PRIMARY KEY NOT NULL,
  "program_id" integer NOT NULL,
  "client_id" integer NOT NULL,
  "start_date" date NOT NULL,
  "end_date" date
);

CREATE TABLE "program_exercise" (
  "id" serial PRIMARY KEY NOT NULL,
  "exercise_id" integer NOT NULL,
  "program_id" integer NOT NULL,
  "set_count" integer NOT NULL,
  "rep_count" integer NOT NULL,
  "rest_period_seconds" integer NOT NULL
);

CREATE TABLE "billing" (
  "billing_id" serial PRIMARY KEY NOT NULL,
  "client_id" integer NOT NULL,
  "amount" decimal(6,2) NOT NULL,
  "payment_due_date" date NOT NULL
);

CREATE TABLE "payments" (
  "payment_id" serial PRIMARY KEY NOT NULL,
  "amount" decimal(6,2) NOT NULL,
  "billing_id" integer NOT NULL,
  "payment_date" date NOT NULL
);

CREATE TABLE "difficulty" (
  "difficulty_id" serial PRIMARY KEY NOT NULL,
  "difficulty_description" varchar(255) NOT NULL,
  "years_experience" integer NOT NULL
);

ALTER TABLE "client_program" ADD FOREIGN KEY ("client_id") REFERENCES "clients" ("client_id");

ALTER TABLE "client_program" ADD FOREIGN KEY ("program_id") REFERENCES "programs" ("program_id");

ALTER TABLE "program_exercise" ADD FOREIGN KEY ("program_id") REFERENCES "programs" ("program_id");

ALTER TABLE "program_exercise" ADD FOREIGN KEY ("exercise_id") REFERENCES "exercises" ("exercise_id");

ALTER TABLE "billing" ADD FOREIGN KEY ("client_id") REFERENCES "clients" ("client_id");

ALTER TABLE "payments" ADD FOREIGN KEY ("billing_id") REFERENCES "billing" ("billing_id");

ALTER TABLE "programs" ADD FOREIGN KEY ("difficulty_id") REFERENCES "difficulty" ("difficulty_id");
