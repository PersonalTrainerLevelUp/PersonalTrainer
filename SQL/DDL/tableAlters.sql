--changeset karl:ddl:alterTable:client_program_FK_clients
--comment: Add clients.client_id as FK to client_program
ALTER TABLE "client_program" 
ADD CONSTRAINT client_program_FK_clients FOREIGN KEY ("client_id") REFERENCES "clients" ("client_id");
--rollback ALTER TABLE "client_program" DROP CONSTRAINT client_program_FK_clients

--changeset karl:ddl:alterTable:client_program_FK_programs
--comment: Add programs.program_id as FK to client_program
ALTER TABLE "client_program"
ADD CONSTRAINT client_program_FK_programs FOREIGN KEY ("program_id") REFERENCES "programs" ("program_id");
--rollback ALTER TABLE "client_program" DROP CONSTRAINT client_program_FK_programs

--changeset karl:ddl:alterTable:program_exercise_FK_programs
--comment: Add programs.program_id as FK to program_exercise
ALTER TABLE "program_exercise"
ADD CONSTRAINT program_exercise_FK_programs FOREIGN KEY ("program_id") REFERENCES "programs" ("program_id");
--rollback ALTER TABLE "program_exercise" DROP CONSTRAINT program_exercise_FK_programs

--changeset karl:ddl:alterTable:program_exercise_FK_exercises
--comment: Add exercises.exercise_id as FK to program_exercise
ALTER TABLE "program_exercise"
ADD CONSTRAINT program_exercise_FK_exercises FOREIGN KEY ("exercise_id") REFERENCES "exercises" ("exercise_id");
--rollback ALTER TABLE "program_exercise" DROP CONSTRAINT program_exercise_FK_exercises

--changeset karl:ddl:alterTable:billing_FK_clients
--comment: Add clients.client_id as FK to billing
ALTER TABLE "billing"
ADD CONSTRAINT billing_FK_clients FOREIGN KEY ("client_id") REFERENCES "clients" ("client_id");
--rollback ALTER TABLE "billing" DROP CONSTRAINT billing_FK_clients

--changeset karl:ddl:alterTable:payments_FK_billing
--comment: Add billing.billing_id as FK to payments
ALTER TABLE "payments"
ADD CONSTRAINT payments_FK_billing FOREIGN KEY ("billing_id") REFERENCES "billing" ("billing_id");
--rollback ALTER TABLE "payments" DROP CONSTRAINT payments_FK_billing

--changeset karl:ddl:alterTable:programs_FK_difficulty
--comment: Add difficulty.difficulty_id as FK to programs
ALTER TABLE "programs"
ADD CONSTRAINT programs_FK_difficulty FOREIGN KEY ("difficulty_id") REFERENCES "difficulty" ("difficulty_id");
--rollback ALTER TABLE "programs" DROP CONSTRAINT programs_FK_difficulty