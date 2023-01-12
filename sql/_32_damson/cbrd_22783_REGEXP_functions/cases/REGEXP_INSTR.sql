-- CBRD-24563 : default regexp library change from cppstd to RE2
set system parameters 'regexp_engine=cppstd';

--mandatory arguments
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', ',[^,]+,');
SELECT REGEXP_INSTR();
SELECT REGEXP_INSTR ('abc');
SELECT REGEXP_INSTR ('aabbb', 'ab{-1,3}$');
SELECT REGEXP_INSTR('', ',[^,]+,');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '');
SELECT REGEXP_INSTR(NULL, ',[^,]+,');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', NULL);

--optional arguments
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 20);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 'a');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 0);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', -5);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 500);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', NULL);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 'ab');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 0);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, -2);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 4);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, NULL);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2, 0);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2, 1);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2, 3);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2, 'a');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 2, NULL);
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 0, 'i');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 0, 'c');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 0, '');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 0, 'A');
SELECT REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 0, NULL);

--functional test
SELECT REGEXP_INSTR(ip, '[^.]+', 1, 1) ip_1
, REGEXP_INSTR(ip, '[^.]+', 1, 2) ip_2
, REGEXP_INSTR(ip, '[^.]+', 1, 3) ip_3
, REGEXP_INSTR(ip, '[^.]+', 1, 4) ip_4
FROM (SELECT '10.100.10.1' ip
UNION ALL SELECT '10.100.1.10'
UNION ALL SELECT '100.10.1.20'
UNION ALL SELECT '2.10.1.140') t
ORDER BY ip_1, ip_2, ip_3, ip_4;

SELECT SUBSTRING('Samseong-ro 86-gil, Gangnam-gu, Seoul', REGEXP_INSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 3, 0)) AS GU_CITY;

WITH V_TEST AS (SELECT 'hello@cubrid.com' EMAIL) SELECT REGEXP_INSTR(EMAIL, '[^@]+', 1, 1) AS "id"
, REGEXP_INSTR(EMAIL, '[^@]+', 1, 2) AS "domain" FROM V_TEST;

drop table if exists p1;
create table p1 (num int primary key, code varchar(40) not null, pos int, occ int, return_opt int, match_type varchar);
insert into p1 values(001, '[a-e]', 3, 2, 1, 'c');
insert into p1 values(002, '[f-z]', 3, 2, 1, 'c');
insert into p1 values(003, '\s', 2, 2, 1, 'c');
insert into p1 values(004, 'a|e|i|o|u', 3, 2, 1, 'c');
select * from p1 order by 1;

DROP TABLE IF EXISTS athlete;
CREATE TABLE athlete (name VARCHAR(40) NOT NULL);
INSERT INTO athlete VALUES ('Fernandez Jaime');
INSERT INTO athlete VALUES ('Feri Attila');
INSERT INTO athlete VALUES ('Felisiak Robert');
INSERT INTO athlete VALUES ('Feklistova Maria');
INSERT INTO athlete VALUES ('Fei Alessandro');
INSERT INTO athlete VALUES ('Li Ge');
INSERT INTO athlete VALUES ('Kelly');
INSERT INTO athlete VALUES ('Jo Sh');
SELECT * FROM athlete ORDER BY 1;

SELECT REGEXP_INSTR(name, '[[:alpha:]]+', 1, 1, 0) AS first_name FROM athlete order by 1;
SELECT REGEXP_INSTR(athlete.name, p1.code), p1.code FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_INSTR(athlete.name, p1.code, p1.pos), p1.code, p1.pos FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_INSTR(athlete.name, p1.code, p1.pos, p1.occ), p1.code, p1.pos, p1.occ FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_INSTR(athlete.name, p1.code, p1.pos, p1.occ, p1.return_opt), p1.code, p1.pos, p1.occ, p1.return_opt FROM athlete, p1 ORDER BY p1.num;
SELECT REGEXP_INSTR(athlete.name, p1.code, p1.pos, p1.occ, p1.return_opt, p1.match_type), p1.code, p1.pos, p1.occ, p1.return_opt, p1.match_type FROM athlete, p1 ORDER BY p1.num;

DROP TABLE IF EXISTS first_name_store;
CREATE TABLE first_name_store ( first_name VARCHAR ) AS SELECT REGEXP_INSTR(name, '[[:alpha:]]+', 1, 1) AS first_name FROM athlete;
SELECT * FROM first_name_store order by 1;

DROP TABLE IF EXISTS first_name_store;
CREATE TABLE first_name_store ( first_name VARCHAR );
INSERT INTO first_name_store SELECT REGEXP_INSTR(name, '[[:alpha:]]+', 1, 1) AS first_name from athlete;
SELECT * FROM first_name_store order by 1;

DROP TABLE IF EXISTS first_name_store;
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS p1;

set system parameters 'regexp_engine=default';

