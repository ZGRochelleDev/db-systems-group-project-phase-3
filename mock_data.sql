USE project;

/* Independent with no foreign keys */
INSERT INTO organization (organization_name, date_founded, headquarters)
VALUES ('The Tak-Louis-Zoe League', '1901-01-01', 'Hamden, CT');

INSERT INTO league (league_name, date_founded)
VALUES ('Mockdataball League', '1901-01-01');

INSERT INTO division (division_name, date_founded)
VALUES ('Eastern Division', '1969-01-01');
VALUES ('Western Division', '1969-01-01');

INSERT INTO sports_club_company (club_name, address, ballpark, home_location)
VALUES ('Quinnipiac Sports Group', '123 Broadway, Hamden, CT', 'Knight Park', 'Hamden, CT');

INSERT INTO sponsor (club_name, sponsor_name, contract)
VALUES
  ('Quinnipiac Sports Group', 'Acme Corp', '3 years, $2.5M'),
  ('Quinnipiac Sports Group', 'NorthStar Bank', '2 years, $1.2M');

INSERT INTO umpire (ssn, name, games_participated_count)
VALUES
  ('222333444', 'Pat Lawson', 120),
  ('333444555', 'Dana Kim', 98),
  ('444555666', 'Morgan Lee', 110),
  ('666777888', 'Jamie Fox', 87);

INSERT INTO injury_type (type_of_injury, treatment, affected_body_part)
VALUES
  ('Hamstring strain', 'Physical therapy + rest', 'Leg'),
  ('Shoulder inflammation', 'Anti-inflammatory + rehab', 'Shoulder');

/* Teams has several references */
INSERT INTO team (team_name, home_stadium)
VALUES
  ('Quinnipiac Bobcats', 'Knight Park'),
  ('Cheshire Bears', 'Bear Field');
  ('Wallingford Stars', 'Star Stadium'),
  ('New Haven Fog', 'Fog Field');

/* 3) Record -> team */
INSERT INTO record (team_name, yr, record)
VALUES
  ('Quinnipiac Bobcats', 2024, '92-70'),
  ('Cheshire Bears', 2024, '88-74');
  ('Wallingford Stars', 2024, '95-67'),
  ('New Haven Fog', 2024, '81-81');

/* Players -> team */
INSERT INTO player (player_id, player_name, ssn, position, cntrct, jersey_number, bio, team_name)
VALUES
  (1, 'Jordan Rivera', '123456789', 'Pitcher', 5000000, 27, 'Ace starter', 'Quinnipiac Bobcats'),
  (2, 'Casey Morgan',  '987654321', 'Shortstop', 3500000, 7,  'Gold glove', 'Cheshire Bears');
  (3, 'Mia Nakamura', '246802468', 'Center Field', 4200000, 12, 'Five-tool threat', 'Wallingford Stars'),
  (4, 'Owen Patel',   '135791357', 'Catcher',      2800000, 33, 'Defensive anchor', 'New Haven Fog');

/* Statistics -> (player, team) */
INSERT INTO statistics
  (player_id, season, team_name, wins, era, whip, strikeouts, batting_avg, homeruns, stolen_base, ops, hits, fielding_pct, errors, defensive_runs_saved)
VALUES
  (1, 2024, 'Quinnipiac Bobcats', 15, 3.210, 1.120, 180, NULL,  NULL, NULL,  NULL, NULL,  NULL, NULL, NULL),
  (2, 2024, 'Cheshire Bears',     NULL, NULL,  NULL,  NULL, 0.289, 18,   22,   0.842, 165, 0.978, 9,  12);
  (3, 2024, 'Wallingford Stars', NULL, NULL, NULL, NULL, 0.301, 24, 31, 0.901, 178, 0.987, 3,  14),
  (4, 2024, 'New Haven Fog', NULL, NULL, NULL, NULL, 0.262, 12, 2,  0.744, 141, 0.992, 5,   9);

/* Agent -> player */
INSERT INTO agent (ssn, player_id, agent_name, salary, agency)
VALUES
  ('555666777', 1, 'Alex Grant', 250000.00, 'Prime Sports'),
  ('111222333', 2, 'Riley Chen', 180000.00, 'NorthStar Agency');
  ('777888999', 3, 'Quinn Harper', 210000.00, 'Coastline Sports'),
  ('888999000', 4, 'Nina Alvarez', 165000.00, 'Bay Talent Group');

/* Injury -> player */
INSERT INTO injury (player_id, type_of_injury, date_of_injury, return_date)
VALUES
  (2, 'Hamstring strain', '2024-05-10', '2024-06-01');
  (4, 'Shoulder inflammation', '2024-04-18', '2024-05-20');

/* Coaches -> team */
INSERT INTO coaches (coach_id, name, team_name, salary, dob, role, hire_date, end_date)
VALUES
  (10, 'Sam Delgado', 'Quinnipiac Bobcats', 1200000.00, '1975-03-14', 'Head Coach',     '2020-11-01', NULL),
  (11, 'Terry Walsh', 'Cheshire Bears',      950000.00, '1980-08-22', 'Pitching Coach', '2022-02-15', NULL);
  (12, 'Harper Stone', 'Wallingford Stars', 1100000.00, '1972-12-09', 'Head Coach', '2021-10-01', NULL),
  (13, 'Devon Reyes',  'New Haven Fog',  900000.00, '1983-06-30', 'Head Coach', '2023-01-10', NULL);

/* (FK -> team for home_team & away_team) */
INSERT INTO game (game_id, location, game_type, home_team, away_team, score_home, score_away, year_played)
VALUES
  (1001, 'Knight Park', 'Regular Season', 'Quinnipiac Bobcats', 'Cheshire Bears', 5, 3, 2024);
  (1002, 'Star Stadium', 'Regular Season', 'Wallingford Stars', 'New Haven Fog', 4, 6, 2024);

/* Tickets + Spectators -> game; tickets -> game) */
INSERT INTO ticket (ticket_id, game_id, seat)
VALUES
  (50001, 1001, 'A-101'),
  (50002, 1001, 'A-102');
  (50003, 1002, 'B-210'),
  (50004, 1002, 'B-211');

INSERT INTO spectator (fan_club_id, game_id, name, ticket_id)
VALUES
  (9001, 1001, 'Taylor Brooks', 50001),
  (9002, 1001, 'Avery Singh',   50002);
  (9003, 1002, 'Riley Chen', 50003),
  (9004, 1002, 'Jamie Park', 50004);

/* Umpire participation -> game */
INSERT INTO umpire_participation (game_id, home_base, first_base, second_base, third_base)
VALUES
  (1001, 'Pat Lawson', 'Dana Kim', 'Morgan Lee', 'Jamie Fox');
  (1002, 'Pat Lawson', 'Dana Kim', 'Morgan Lee', 'Jamie Fox');
