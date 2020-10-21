DROP TABLE IF EXISTS participant;

CREATE TABLE participant(
host_year INT NOT NULL,
nation_code CHAR(3) NOT NULL,
gold INT DEFAULT 0,
silver INT DEFAULT 0,
bronze INT DEFAULT 0,
CONSTRAINT pk_participant_host_year_nation_code PRIMARY KEY(host_year,nation_code));

INSERT INTO participant (host_year, nation_code, gold, silver, bronze) VALUES (2004, 'ZAM', 0, 0, 0);
INSERT INTO participant (host_year, nation_code, gold, silver, bronze) VALUES (2004, 'ISV', 0, 0, 0);
INSERT INTO participant (host_year, nation_code, gold, silver, bronze) VALUES (2004, 'VIE', 0, 0, 0);
INSERT INTO participant (host_year, nation_code, gold, silver, bronze) VALUES (2004, 'VAN', 0, 0, 0);
INSERT INTO participant (host_year, nation_code, gold, silver, bronze) VALUES (2004, 'YEM', 0, 0, 0);

SELECT (SELECT 1), TO_CHAR (SUM (host_year) OVER (ORDER BY host_year))
FROM participant LIMIT 1;

SELECT TO_CHAR(SUM(host_year) OVER (ORDER BY host_year))
FROM participant LIMIT 1;

SELECT (SELECT 1), SUM(host_year) OVER (ORDER BY host_year)
FROM participant LIMIT 1;

DROP TABLE participant;
