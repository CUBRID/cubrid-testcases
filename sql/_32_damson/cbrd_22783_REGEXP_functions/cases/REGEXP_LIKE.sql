--mandatory arguments
SELECT REGEXP_LIKE('123123123123123', '(12)3', 'i');
SELECT REGEXP_LIKE();
SELECT REGEXP_LIKE ('abc');
SELECT REGEXP_LIKE ('aabbb', 'ab{-1,3}$');
SELECT REGEXP_LIKE('', ',[^,]+,');
SELECT REGEXP_LIKE('123', '');
SELECT REGEXP_LIKE(NULL, ',[^,]+,');
SELECT REGEXP_LIKE('123123123123123', NULL);

--match_type
SELECT REGEXP_LIKE('ABCABC', 'a|b', 'i');
SELECT REGEXP_LIKE('ABCABC', 'a|b', 'c');
SELECT REGEXP_LIKE('ABCABCabcabc', 'a|b', '');
SELECT REGEXP_LIKE('ABCABCabcabc', 'a|b', 'a');
SELECT REGEXP_LIKE('ABCABCabcabc', 'a|b', NULL);

--functional test
SELECT REGEXP_LIKE('abcabcabcabcabc', 'abc') AS C1, REGEXP_LIKE('abcabcabcabcabc', 'abd') AS C2;

drop table if exists p1;
create table p1 (num int primary key, code varchar(40) not null, match_type varchar);
insert into p1 values(001, '\-', 'c');
insert into p1 values(002, '^f[[:alpha:]]+ a.+', 'c');
insert into p1 values(003, '\s', 'c');
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
INSERT INTO athlete VALUES ('Fei Alessandro');
INSERT INTO athlete VALUES ('Feri Attila');
SELECT * FROM athlete ORDER BY 1;

SELECT REGEXP_LIKE (name, '[[:alpha:]]+') FROM athlete order by 1;
SELECT REGEXP_LIKE(athlete.name, p1.code), p1.code FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_LIKE(athlete.name, p1.code, p1.match_type), p1.code, p1.match_type FROM athlete, p1 ORDER BY p1.num;

SELECT name FROM athlete WHERE REGEXP_LIKE(name, '^F[[:alpha:]]+ A.+') order by 1;

DROP TABLE IF EXISTS many_word_name;
CREATE TABLE many_word_name ( name VARCHAR ) AS SELECT name FROM athlete WHERE REGEXP_LIKE(name, '^F[[:alpha:]]+ A.+');
SELECT * FROM many_word_name order by 1;

DROP TABLE IF EXISTS many_word_name;
CREATE TABLE many_word_name ( name VARCHAR ); 
INSERT INTO many_word_name SELECT name FROM athlete WHERE REGEXP_LIKE(name, '^F[[:alpha:]]+ A.+');
SELECT * FROM many_word_name order by 1;

DROP TABLE IF EXISTS many_word_name;
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS p1;
