CREATE TABLE users (
  userId       SERIAL PRIMARY KEY,
  role     		TEXT NOT NULL CHECK (role IN ('member','trainer','admin'))
);

CREATE TABLE members (
  userid      	INT PRIMARY KEY UNIQUE NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
  fullName		TEXT NOT NULL,
  dob          	DATE,
  contactInfo   TEXT
);

CREATE TABLE trainers (
  userid       INT PRIMARY KEY UNIQUE NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
  fullName	   TEXT NOT NULL,
  availability TEXT  
);

CREATE TABLE adminstrative_staff (
  userid       INT PRIMARY KEY UNIQUE NOT NULL REFERENCES users(userId) ON DELETE CASCADE,
  fullName	   TEXT NOT NULL
);

CREATE TABLE fitness_goals (
  goal_id      SERIAL PRIMARY KEY,
  member_id    INT NOT NULL REFERENCES members(userId) ON DELETE CASCADE,
  description  TEXT NOT NULL,
  target_value NUMERIC,
  target_unit  TEXT,
  start_date   DATE DEFAULT CURRENT_DATE,
  target_date  DATE,
  status       TEXT DEFAULT 'active' CHECK (status IN ('active','achieved','cancelled'))
);

CREATE TABLE health_metrics (
  metric_id    SERIAL PRIMARY KEY,
  member_id    INT NOT NULL REFERENCES members(userId) ON DELETE CASCADE,
  recorded_at  timestamptz NOT NULL DEFAULT now(),
  metric_type  TEXT NOT NULL,
  metric_value NUMERIC NOT NULL,
  unit         TEXT,
  notes        TEXT
);

CREATE TABLE rooms (
  room_id      SERIAL PRIMARY KEY,
  name         TEXT UNIQUE NOT NULL,
  capacity     INT NOT NULL DEFAULT 1,
  location     TEXT
);

CREATE TABLE equipment (
  equipment_id SERIAL PRIMARY KEY,
  name         TEXT NOT NULL,
  room_id      INT REFERENCES rooms(room_id),
  status       TEXT DEFAULT 'operational' CHECK (status IN ('operational','needs_repair','out_of_service')),
  notes        TEXT
);

CREATE TABLE equipmentLog (
  record_id		 SERIAL PRIMARY KEY,
  equipment_id   INT REFERENCES equipment(equipment_id),
  status         TEXT DEFAULT 'open' CHECK (status IN ('open','in_progress','resolved')),
  maintanence    TEXT NOT NULL,
  date_of_log	 date
);

CREATE TABLE programs (
  programId     SERIAL PRIMARY KEY,
  programType	TEXT,
  schedule		TEXT,
  room			INT REFERENCES rooms(room_id),
  instructor	TEXT REFERENCES trainers(fullName)
);

CREATE TABLE group_fitness_classes (
  programId		INT PRIMARY KEY UNIQUE NOT NULL REFERENCES programs(programId) ON DELETE CASCADE,
  programType	TEXT REFERENCES programs(programType),
  schedule		TEXT REFERENCES programs(schedule),
  room			INT REFERENCES programs(room),
  instructor	TEXT REFERENCES program(instructor),
  capacity		INT
);

CREATE TABLE personal_sessions (
  programId		INT PRIMARY KEY UNIQUE NOT NULL REFERENCES programs(programId) ON DELETE CASCADE,
  programType	TEXT REFERENCES programs(programType),
  schedule		TEXT REFERENCES programs(schedule),
  room			INT REFERENCES programs(room),
  instructor	TEXT REFERENCES program(instructor),
  member_join   TEXT REFERENCES member(fullName)
);

CREATE TABLE class_sessions (
  class_session_id SERIAL PRIMARY KEY,
  class_id     INT NOT NULL REFERENCES programs(class_id),
  trainer_id   INT REFERENCES trainers(userid),
  room_id      INT REFERENCES rooms(room_id),
  start_ts     timestamptz NOT NULL,
  end_ts       timestamptz NOT NULL,
  status       TEXT DEFAULT 'scheduled' CHECK (status IN ('scheduled','cancelled','completed')),
  CHECK (end_ts > start_ts)
);

CREATE TABLE class_registrations (
  registration_id SERIAL PRIMARY KEY,
  class_session_id INT NOT NULL REFERENCES class_sessions(class_session_id) ON DELETE CASCADE,
  member_id     INT NOT NULL REFERENCES members(userid),
  registered_at timestamptz DEFAULT now(),
  UNIQUE (class_session_id, member_id)
);

CREATE TABLE bills (
  bill_id	   SERIAL PRIMARY KEY,
  amount       NUMERIC NOT NULL,
  bill_date	   date,
  billType	   TEXT NOT NULL
);

CREATE TABLE payments_log (
  payment_id   INT PRIMARY KEY REFERENCES bills(bill_id),
  status       TEXT NOT NULL,
  amount       NUMERIC NOT NULL,
  method       TEXT
);