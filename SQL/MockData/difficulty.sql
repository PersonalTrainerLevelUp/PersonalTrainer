--changeset karl:dml:mockData:difficulty
--comment: Add mock data to difficulty
insert into difficulty (difficulty_id, difficulty_description, years_experience) values (1, 'Beginner', 0),
(2, 'Intermediate', 2),
(3, 'Advanced', 5),
(4, 'Expert', 8);
--rollback DELETE FROM "difficulty";