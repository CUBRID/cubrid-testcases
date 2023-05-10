-- create java sp
CREATE OR REPLACE FUNCTION intTest(x int) RETURN int AS LANGUAGE JAVA NAME 'SpTest7.typetestint(int) return int';

DROP IF EXISTS bonus, std;

-- create data
CREATE TABLE bonus (std_id INT, addscore NUMERIC(5,2));
CREATE INDEX i_bonus_std_id ON bonus (std_id);

INSERT INTO bonus VALUES (1,10);
INSERT INTO bonus VALUES (2,10);
INSERT INTO bonus VALUES (3,10);
INSERT INTO bonus VALUES (4,10);
INSERT INTO bonus VALUES (5,10);
INSERT INTO bonus VALUES (6,10);
INSERT INTO bonus VALUES (7,10);
INSERT INTO bonus VALUES (8,10);
INSERT INTO bonus VALUES (9,10);
INSERT INTO bonus VALUES (10,10);

CREATE TABLE std (std_id INT, score INT);
CREATE INDEX i_std_std_id  ON std (std_id);
CREATE INDEX i_std_std_id_score ON std (std_id, score);

INSERT INTO std VALUES (1,60);
INSERT INTO std VALUES (2,70);
INSERT INTO std VALUES (3,80);
INSERT INTO std VALUES (4,35);
INSERT INTO std VALUES (5,55);
INSERT INTO std VALUES (6,30);
INSERT INTO std VALUES (7,65);
INSERT INTO std VALUES (8,65);
INSERT INTO std VALUES (9,70);
INSERT INTO std VALUES (10,22);
INSERT INTO std VALUES (11,67);
INSERT INTO std VALUES (12,20);
INSERT INTO std VALUES (13,45);
INSERT INTO std VALUES (14,30);

SELECT * FROM bonus;
SELECT * FROM std;

MERGE INTO bonus t USING (SELECT std_id, intTest(score) score  FROM std WHERE intTest(score) < 40) s
ON t.std_id = intTest( s.std_id )
WHEN MATCHED THEN
UPDATE SET t.addscore = t.addscore + intTest(s.score ) * 0.1
WHEN NOT MATCHED THEN
INSERT (t.std_id, t.addscore) VALUES (s.std_id, 10 + intTest(s.score) * 0.1) WHERE intTest(s.score) <= 30;

SELECT * FROM bonus;

SELECT distinct(inttest(score)) FROM std;
-- compare
SELECT distinct(score) FROM std;

DROP FUNCTION intTest;

DROP bonus, std;

