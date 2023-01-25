-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

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
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS p1;

CREATE TABLE athlete (id INT PRIMARY KEY, name VARCHAR(40) NOT NULL);
INSERT INTO athlete VALUES (10998, 'Fernandez Jaime');
INSERT INTO athlete VALUES (10997, 'Fernandez Isabel');
INSERT INTO athlete VALUES (10996, 'Fernandez Gigi');
INSERT INTO athlete VALUES (10993, 'Feri Attila');
INSERT INTO athlete VALUES (10992, 'Felisiak Robert');
INSERT INTO athlete VALUES (10991, 'Feklistova Maria');
INSERT INTO athlete VALUES (10990, 'Fei Alessandro');
INSERT INTO athlete VALUES (12163, 'Li Ge');
INSERT INTO athlete VALUES (14912, 'Kelly');
INSERT INTO athlete VALUES (14873, 'Jo Sh');
SELECT * FROM athlete ORDER BY 1;

create table p1(id int primary key, code varchar(40) not null, pos int, occ int, match_type varchar);
insert into p1 values(15000, '[a-e]', 3, 2, 'c');
insert into p1 values(15001, '[f-z]', 3, 2, 'c');
insert into p1 values(15002, '\s', 2, 2, 'c');
insert into p1 values(15003, 'a|e|i|o|u', 3, 2, 'c');
select * from p1 order by 1;

SELECT REGEXP_REPLACE (name, '[a-e]', '#'), REGEXP_REPLACE (name, '[f-z]', '@') FROM athlete ORDER BY 1;
SELECT REGEXP_REPLACE (name, '[a-e]', '#', 3, 0, 'i') from athlete ORDER BY 1;
SELECT REGEXP_REPLACE (name, '[a-e]', '#', 3, 0, 'c') from athlete ORDER BY 1;
SELECT name FROM athlete WHERE LENGTH (REGEXP_REPLACE (name, '\s', '')) < 5 ORDER BY 1;

--reference from external table
select REGEXP_REPLACE(athlete.name, p1.code, '#'), p1.code from athlete, p1 order by athlete.id;
select REGEXP_REPLACE(athlete.name, p1.code, '#', p1.pos), p1.code, p1.pos from athlete, p1 order by athlete.id;
select REGEXP_REPLACE(athlete.name, p1.code, '#', p1.pos, p1.occ), p1.code, p1.pos, p1.occ from athlete, p1 order by athlete.id;
select REGEXP_REPLACE(athlete.name, p1.code, '#', p1.pos, p1.occ, p1.match_type), p1.code, p1.pos, p1.occ, p1.match_type from athlete, p1 order by athlete.id;

WITH V_TEST AS (SELECT 'hello@cubrid.com' EMAIL)SELECT REGEXP_REPLACE(EMAIL, 'hello', 'cub') AS "id" FROM V_TEST ORDER BY 1;

DROP TABLE IF EXISTS new_athlete;
CREATE TABLE new_athlete ( encrypted_name VARCHAR ) AS SELECT REGEXP_REPLACE (name, '[a|e|i|o|u]', '#') AS encrypted_name from athlete ORDER BY 1;
SELECT * from new_athlete ORDER BY 1;

DROP TABLE IF EXISTS new_athlete;
CREATE TABLE new_athlete (encrypted_name VARCHAR);
INSERT INTO new_athlete SELECT REGEXP_REPLACE (name, '[a|e|i|o|u]', '#') AS encrypted_name from athlete ORDER BY 1;
SELECT * from new_athlete ORDER BY 1;

DROP TABLE IF EXISTS new_athlete;
DROP TABLE IF EXISTS p1;
DROP TABLE IF EXISTS athlete;

set system parameters 'regexp_engine=default';

