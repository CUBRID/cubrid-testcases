--mandatory argument
SELECT REGEXP_REPLACE ('TechOnTheNet is a great resource', '^(\S*)', 'CheckYourMath');
SELECT REGEXP_REPLACE();
SELECT REGEXP_REPLACE ('abc');
SELECT REGEXP_REPLACE ('aabbb', 'ab{-1,3}$');
SELECT REGEXP_REPLACE ('', 'a|e|i|o|u', '#');
SELECT REGEXP_REPLACE ('abc', '', '#');
SELECT REGEXP_REPLACE ('abc', 'a|e|i|o|u', '');
SELECT REGEXP_REPLACE ('', '', '#');
SELECT REGEXP_REPLACE ('', 'a|e|i|o|u', '');
SELECT REGEXP_REPLACE ('abc', '', '');
SELECT REGEXP_REPLACE ('', '', '');
SELECT REGEXP_REPLACE (NULL, 'a|e|i|o|u', '#');
SELECT REGEXP_REPLACE ('abc', NULL, '#');
SELECT REGEXP_REPLACE ('abc', 'a|e|i|o|u', NULL);
SELECT REGEXP_REPLACE (NULL, NULL, '#');
SELECT REGEXP_REPLACE (NULL, 'a|e|i|o|u', NULL);
SELECT REGEXP_REPLACE ('abc', NULL, NULL);
SELECT REGEXP_REPLACE (NULL, NULL, NULL);

--optional arguments
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 6);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 'a');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 0);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', -5);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 9999);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', NULL, 2);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 6);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 6, 'a');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 2, 0);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 2, -1);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 1, 9999);
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 1, NULL); 
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 3, 2, 'i');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 3, 2, 'c');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 1, 0, '');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 1, 2, 'ia');
SELECT REGEXP_REPLACE ('TechOnTheNet', 'a|e|i|o|u', '#', 1, 2, NULL);

--functional test
CREATE TABLE athlete (
code INT AUTO_INCREMENT PRIMARY KEY
, name VARCHAR(40) NOT NULL
, gender CHAR(1)
, nation_code CHAR(3)
, event VARCHAR(30)
);

INSERT INTO athlete VALUES 
(10998, 'Fernandez Jaime', 'M', 'AUS', 'Rowing')
,(10997, 'Fernandez Isabel', 'W', 'ESP', 'Judo')
,(10996, 'Fernandez Gigi', 'W', 'USA', 'Tennis')
,(10993, 'Feri Attila', 'M', 'HUN', 'Weightlifting')
,(10992, 'Felisiak Robert', 'M', 'GER', 'Fencing')
,(10991, 'Feklistova Maria', 'W', 'RUS', 'Shooting')
,(10990, 'Fei Alessandro', 'M', 'ITA', 'Volleyball')
,(12163, 'Li Ge', 'M', 'CHN', 'Gymnastics')
,(14912, 'Kelly', 'W', 'BRA', 'Football')
,(14873, 'Jo Sh', 'M', 'KOR', 'Boxing');

SELECT 
REGEXP_REPLACE (name, '[a-d]', '#'), REGEXP_REPLACE (name, '[e-z]', '@') 
FROM athlete ORDER BY 1 LIMIT 5;

SELECT REGEXP_REPLACE (name, '[a-d]', '#', 6, 0, 'i') from athlete ORDER BY 1 LIMIT 5;

SELECT REGEXP_REPLACE (name, '[a-d]', '#', 6, 0, 'c') from athlete ORDER BY 1 LIMIT 5;

SELECT name FROM athlete 
WHERE LENGTH (REGEXP_REPLACE (name, '\s', '')) < 5 ORDER BY 1;

WITH V_TEST AS (SELECT 'hello@cubrid.com' EMAIL)
SELECT REGEXP_REPLACE(EMAIL, 'hello', 'cub') AS "id" FROM V_TEST ORDER BY 1;

CREATE TABLE new_athlete ( encrypted_name VARCHAR ) AS SELECT REGEXP_REPLACE (name, '[a|e|i|o|u]', '#') AS encrypted_name from athlete ORDER BY 1 LIMIT 10;
SELECT * from new_athlete ORDER BY 1;
DROP TABLE new_athlete;

CREATE TABLE new_athlete (encrypted_name VARCHAR);
INSERT INTO new_athlete SELECT REGEXP_REPLACE (name, '[a|e|i|o|u]', '#') AS encrypted_name from athlete ORDER BY 1 LIMIT 10;
SELECT * from new_athlete ORDER BY 1;
DROP TABLE new_athlete;

DROP TABLE athlete;
