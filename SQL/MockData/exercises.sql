--changeset karl:dml:mockData:exercises
--comment: Add mock data to exercises
insert into exercises (exercise_name, exercise_type, exercise_description) values ('Push-up', 'Chest', 'Start in a plank position with your hands directly under your shoulders.'),
('Squat', 'Legs', 'Stand with your feet shoulder-width apart. Lower your body as if you were sitting back into a chair.'),
('Lunges', 'Legs', 'Stand with your feet hip-width apart. Step forward with one leg and lower your body until both knees are bent at a 90-degree angle.'),
('Deadlift', 'Back', 'Stand with your feet shoulder-width apart, holding a barbell.'),
('Pull-up', 'Back', 'Hang from a pull-up bar.'),
('Plank', 'Core', 'Start in a push-up position with your hands directly under your shoulders.'),
('Russian Twist', 'Core', 'Sit on the floor.'),
('Bicep Curl', 'Arms', 'Stand with a dumbbell in each hand, palms facing forward.'),
('Tricep Dip', 'Arms', 'Sit on a bench with your hands gripping the edge, fingers pointing forward.'),
('Burpee', 'Full body', 'Start in a standing position, then squat down and place your hands on the ground.'),
('Mountain Climbers', 'Full body', 'Start in a plank position.'),
('Box Jump', 'Legs', 'Stand in front of a sturdy box or platform.'),
('Chest Press', 'Chest', 'Lie on a bench with a dumbbell in each hand, elbows bent at 90-degree angles.'),
('Leg Press', 'Legs', 'Sit on a leg press machine with your feet on the platform shoulder-width apart.'),
('Lat Pulldown', 'Back', 'Sit at a lat pulldown machine with your knees braced under the pads.'),
('Russian Kettlebell Swing', 'Back', 'Stand with your feet shoulder-width apart.'),
('Plank with Leg Lift', 'Core', 'Start in a plank position. Lift one leg off the ground while keeping your hips level and core engaged.'),
('Hammer Curl', 'Arms', 'Stand with a dumbbell in each hand, palms facing each other.'),
('Skull Crushers', 'Arms', 'Lie on a bench with a dumbbell in each hand.'),
('Jumping Jacks', 'Full body', 'Start standing with your feet together and arms at your sides.');
--rollback DELETE FROM "exercises";