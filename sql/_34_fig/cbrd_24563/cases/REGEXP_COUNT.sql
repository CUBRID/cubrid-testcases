-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=re2';

--mandatory arguments
SELECT REGEXP_COUNT('123123123123123', '(12)3', 1, 'i');
SELECT REGEXP_COUNT();
SELECT REGEXP_COUNT ('abc');
SELECT REGEXP_COUNT ('aabbb', 'ab{-1,3}$');
SELECT REGEXP_COUNT('', ',[^,]+,');
SELECT REGEXP_COUNT('123', '');
SELECT REGEXP_COUNT(NULL, ',[^,]+,');
SELECT REGEXP_COUNT('123123123123123', NULL);

--optional arguments
SELECT REGEXP_COUNT('123123123123123', '(12)3', 5);
SELECT REGEXP_COUNT('123123123123123', '(12)3', 'a');
SELECT REGEXP_COUNT('123123123123123', '(12)3', 0);
SELECT REGEXP_COUNT('123123123123123', '(12)3', -3);
SELECT REGEXP_COUNT('123123123123123', '(12)3', 500);
SELECT REGEXP_COUNT('123123123123123', '(12)3', NULL);
SELECT REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, 'i');
SELECT REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, 'c');
SELECT REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, '');
SELECT REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, 'a');
SELECT REGEXP_COUNT('ABCABCabcabc', 'a|b', 1, NULL);

--functional test
SELECT REGEXP_COUNT('abcabcabcabcabc', 'abc', 1) AS C1, 
REGEXP_COUNT('abcabcabcabcabc', 'abc', 4) AS C2;

drop table if exists p1;
create table p1 (num int primary key, code varchar(40) not null, pos int, match_type varchar);
insert into p1 values(001, '[a-e]', 3, 'c');
insert into p1 values(002, '[f-z]', 2, 'c');
insert into p1 values(003, '[[:alpha:]]+', 1, 'c');
insert into p1 values(004, 'a|e|i|o|u', 2, 'c');
select * from p1 order by 1;

DROP TABLE IF EXISTS athlete;
CREATE TABLE athlete (name VARCHAR(40) NOT NULL);
INSERT INTO athlete VALUES ('Aline');
INSERT INTO athlete VALUES ('Balachov Roman');
INSERT INTO athlete VALUES ('Chiang Tai-Chuan');
INSERT INTO athlete VALUES ('Chamot Jose Antonio');
INSERT INTO athlete VALUES ('De La Hoya Oscar');
INSERT INTO athlete VALUES ('Guidry-White Carlette D.');
INSERT INTO athlete VALUES ('Oliva Hortencia De Fatima Marcari');
INSERT INTO athlete VALUES ('Van Der Ploeg G. Jose M.');
SELECT * FROM athlete ORDER BY 1;

SELECT REGEXP_COUNT(name, '[[:alpha:]]+') FROM athlete order by 1;
SELECT REGEXP_COUNT(athlete.name, p1.code), p1.code FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_COUNT(athlete.name, p1.code, p1.pos), p1.code, p1.pos FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_COUNT(athlete.name, p1.code, p1.pos, p1.match_type), p1.code, p1.pos,  p1.match_type FROM athlete, p1 ORDER BY p1.num;

SELECT name FROM athlete WHERE REGEXP_COUNT (name, '[[:alpha:]]+') > 5 order by 1;

DROP TABLE IF EXISTS many_word_name;
CREATE TABLE many_word_name ( name VARCHAR ) AS SELECT name FROM athlete WHERE REGEXP_COUNT (name, '[[:alpha:]]+') > 2;
SELECT * FROM many_word_name order by 1;

DROP TABLE IF EXISTS many_word_name;
CREATE TABLE many_word_name ( name VARCHAR );
INSERT INTO many_word_name SELECT name FROM athlete WHERE REGEXP_COUNT (name, '[[:alpha:]]+') > 2;
SELECT * FROM many_word_name order by 1;

DROP TABLE IF EXISTS many_word_name;
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS p1;


set system parameters 'regexp_engine=default';

