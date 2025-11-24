CREATE TABLE organization (
  organization_name VARCHAR(45) NOT NULL,
  date_founded DATE NULL,
  headquarters VARCHAR(45) NULL,
  PRIMARY KEY (organization_name));

CREATE TABLE team(
    team_name VARCHAR(45) NOT NULL,
    home_stadium VARCHAR(45) NOT NULL,
    PRIMARY KEY(team_name),
);

CREATE TABLE record(
    team_name VARCHAR(45) NOT NULL,
    yr YEAR(4),
    record VARCHAR(45),
    PRIMARY KEY(team_name)
);

CREATE TABLE player(
    player_id INT NOT NULL,
    player_name VARCHAR(45),
    ssn CHAR(9),
    position VARCHAR(45),
    cntrct INT,
    jersey_number DECIMAL,
    bio VARCHAR(45),
    team_name VARCHAR(45)
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

CREATE TABLE statistics(
    player_id INT NOT NULL,
    season YEAR(4) NOT NULL,
    team_name VARCHAR(45),
    wins INT,
    era DECIMAL,
    whip DECIMAL,
    strikeouts INT,
    batting_avg DECIMAL,
    homeruns INT,
    stolen_base INT,
    ops DECIMAL,
    hits INT,
    fielding_pct DECIMAL,
    errors INT,
    defensive_runs_saved INT,
    PRIMARY KEY(player_id, season, team_name),
    FOREIGN KEY (player_id) REFERENCES player(player_id),
    FOREIGN KEY (team_name) REFERENCES team(team_name),
    FOREIGN KEY (season) REFERENCES record(yr)
);

CREATE TABLE agent(
    ssn CHAR(9) NOT NULL,
    player_id INT NOT NULL,
    agent_name VARCHAR(45),
    salary DECIMAL,
    agency VARCHAR(45),
    PRIMARY KEY(ssn),
    FOREIGN KEY (player_id) REFERENCES player(player_id)
);