INSERT INTO users (role) VALUES
('member'),
('member'),
('trainer'),
('admin');

INSERT INTO members (userId, fullName, dob, contactInfo) VALUES
(1, 'Bob Johnson', '1995-04-12', '123-123-123'),
(2, 'Peter Smith', '1988-11-23', '613-613-613');

INSERT INTO trainers (userId, fullName, availability) VALUES
(3, 'Daniel Lee', NULL);

INSERT INTO adminstrative_staff (userId, fullName) VALUES
(4, 'Sam Smith');

INSERT INTO equipment (equipment_id, name, room_id, status, notes) VALUES
(1, 'Treadmill One', 34, 'operational', ''),
(2, 'Bench Press Station', 12, 'operational', ''),
(3, 'Rowing Machine', 36, 'operational', '');

INSERT INTO programs (programId, programType, schedule, room, instructor) VALUES
(1, 'Yoga Class', 'Mon/Wed 6 PM', 15, 'Daniel Lee'),
(2, 'Strength Training', 'Tue/Thu 7 PM', 23, 'Daniel Lee');