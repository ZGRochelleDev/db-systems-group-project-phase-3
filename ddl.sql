USE project;

CREATE TABLE organization (
  organization_name VARCHAR(45) NOT NULL,
  date_founded DATE,
  headquarters VARCHAR(45),
  PRIMARY KEY (organization_name)
);

CREATE TABLE team(
    team_name VARCHAR(45) NOT NULL,
    home_stadium VARCHAR(45) NOT NULL,
    PRIMARY KEY(team_name)
);

CREATE TABLE record(
    team_name VARCHAR(45) NOT NULL,
    yr YEAR(4) NOT NULL,
    wins INT,
    loss INT,
    PRIMARY KEY(team_name, yr),
    FOREIGN KEY (team_name) REFERENCES team(team_name)
);

CREATE TABLE player(
    player_id INT NOT NULL,
    player_name VARCHAR(45),
    ssn CHAR(9),
    position VARCHAR(45),
    cntrct INT,
    jersey_number INT,
    bio VARCHAR(45),
    team_name VARCHAR(45),
    PRIMARY KEY(player_id),
    FOREIGN KEY (team_name) REFERENCES team(team_name)
);

CREATE TABLE league(
    league_name VARCHAR(45) NOT NULL,
    date_founded DATE,
    PRIMARY KEY(league_name)
);

CREATE TABLE division(
    division_name VARCHAR(45) NOT NULL,
    date_founded DATE,
    PRIMARY KEY(division_name)
);

CREATE TABLE player_statistics(
    player_id INT NOT NULL,
    season YEAR(4) NOT NULL,
    team_name VARCHAR(45),
    wins INT,
    era DECIMAL(6,3),
    whip DECIMAL(6,3),
    strikeouts INT,
    batting_avg DECIMAL(6,3),
    homeruns INT,
    stolen_base INT,
    ops DECIMAL(6,3),
    hits INT,
    fielding_pct DECIMAL(6,3),
    errors INT,
    defensive_runs_saved INT,
    PRIMARY KEY(player_id, season, team_name),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_name, season) REFERENCES record(team_name, yr)
);

CREATE TABLE agent(
    ssn CHAR(9) NOT NULL,
    player_id INT NOT NULL,
    agent_name VARCHAR(45),
    salary DECIMAL(10,2),
    agency VARCHAR(45),
    PRIMARY KEY(ssn),
    FOREIGN KEY (player_id) REFERENCES player(player_id)
);

CREATE TABLE injury(
    player_id INT NOT NULL,
    type_of_injury VARCHAR(255) NOT NULL,
    date_of_injury DATE NOT NULL,
    return_date DATE,
    PRIMARY KEY (player_id, type_of_injury, date_of_injury),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (type_of_injury) REFERENCES injury_type(type_of_injury)
      ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE injury_type(
    type_of_injury VARCHAR(255) NOT NULL,
    treatment VARCHAR(255),
    affected_body_part VARCHAR(255),
    PRIMARY KEY(type_of_injury)
);

CREATE TABLE coach( 
    coach_id INT NOT NULL,
    name VARCHAR(255),
    team_name VARCHAR(255),
    salary DECIMAL(10,2),
    dob DATE,
    role VARCHAR(255),
    hire_date DATE,
    end_date DATE,
    PRIMARY KEY(coach_id),
    FOREIGN KEY (team_name) REFERENCES team(team_name)
      ON UPDATE RESTRICT ON DELETE SET NULL
);

CREATE TABLE game(
    game_id INT NOT NULL,
    location VARCHAR(255),
    game_type VARCHAR(255),
    home_team VARCHAR(255),
    away_team VARCHAR(255),
    score_home INT,
    score_away INT,
    year_played INT,
    PRIMARY KEY(game_id),
    FOREIGN KEY (home_team) REFERENCES team(team_name)
      ON UPDATE RESTRICT ON DELETE CASCADE,
    FOREIGN KEY (away_team) REFERENCES team(team_name)
      ON UPDATE RESTRICT ON DELETE CASCADE
);

CREATE TABLE umpire_participation(
    game_id INT NOT NULL,
    home_base VARCHAR(255),
    first_base VARCHAR(255),
    second_base VARCHAR(255),
    third_base VARCHAR(255),
    PRIMARY KEY(game_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
    FOREIGN KEY (home_base) REFERENCES umpire(ssn)
    FOREIGN KEY (first_base) REFERENCES umpire(ssn)
    FOREIGN KEY (second_base) REFERENCES umpire(ssn)
    FOREIGN KEY (third_base) REFERENCES umpire(ssn)
);

CREATE TABLE spectator(
    fan_club_id INT NOT NULL,
    game_id INT NOT NULL,
    name VARCHAR(255),
    ticket_id INT,
    PRIMARY KEY(fan_club_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
      ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE ticket(
    ticket_id INT NOT NULL,
    game_id INT NOT NULL,
    seat VARCHAR(50),
    PRIMARY KEY(ticket_id),
    FOREIGN KEY (game_id) REFERENCES game(game_id)
      ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE sports_club_company( 
    club_name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    ballpark VARCHAR(255),
    home_location VARCHAR(255),
    PRIMARY KEY(club_name)
);

CREATE TABLE sponsor(
    club_name VARCHAR(255) NOT NULL,
    sponsor_name VARCHAR(255) NOT NULL,
    contract VARCHAR(255),
    PRIMARY KEY(club_name, sponsor_name),
    FOREIGN KEY (club_name) REFERENCES sports_club_company(club_name)
      ON DELETE CASCADE ON UPDATE RESTRICT
);

CREATE TABLE umpire(
    ssn CHAR(9) NOT NULL,
    name VARCHAR(255),
    games_participated_count INT,
    PRIMARY KEY(ssn)
);
