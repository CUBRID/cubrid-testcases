--mandatory argument
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', ',[^,]+,');
SELECT REGEXP_SUBSTR();
SELECT REGEXP_SUBSTR ('abc');
SELECT REGEXP_SUBSTR ('aabbb', 'ab{-1,3}$');
SELECT REGEXP_SUBSTR('', ',[^,]+,');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '');
SELECT REGEXP_SUBSTR(NULL, ',[^,]+,');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', NULL);

--optional arguments
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 1);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 'ab');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 0);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, -2);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 4);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, NULL);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 1);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 'ab');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 0);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, -2);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, 4);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-\w+', 1, NULL);
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 'i');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 'c');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, '');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 'A');
SELECT REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, NULL);

--functional test
SELECT REGEXP_SUBSTR(ip, '[^.]+', 1, 1) ip_1
, REGEXP_SUBSTR(ip, '[^.]+', 1, 2) ip_2
, REGEXP_SUBSTR(ip, '[^.]+', 1, 3) ip_3
, REGEXP_SUBSTR(ip, '[^.]+', 1, 4) ip_4
FROM (SELECT '10.100.10.1' ip
UNION ALL SELECT '10.100.1.10'
UNION ALL SELECT '100.10.1.20'
UNION ALL SELECT '2.10.1.140') t
ORDER BY ip_1, ip_2, ip_3, ip_4;

SELECT BIT_LENGTH(REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 'i'));

WITH V_TEST AS (SELECT 'hello@cubrid.com' AS EMAIL)
SELECT REGEXP_SUBSTR(EMAIL, '[^@]+', 1, 1) AS "id", REGEXP_SUBSTR(EMAIL, '[^@]+', 1, 2) AS "domain" FROM V_TEST;

DROP TABLE IF EXISTS email;
CREATE TABLE email (id VARCHAR(40) NOT NULL);
INSERT INTO email VALUES ('hello@cubrid.com');
INSERT INTO email VALUES ('test@cubrid.org');
INSERT INTO email VALUES ('dummy@cubrid.net');
INSERT INTO email VALUES ('sample@google.com');
INSERT INTO email VALUES ('demo@google.net');
SELECT * FROM email ORDER BY 1;

drop table if exists p1;
create table p1 (num int primary key, code varchar(40) not null, pos int, occ int, match_type varchar);
insert into p1 values (001, '[[:alpha:]]+', 1, 1, 'c');
insert into p1 values (002, '[^@]+', 1, 1, 'c');
insert into p1 values (003, '[^@]+', 1, 2, 'c');
insert into p1 values (004, '[^.]+', 1, 2, 'c');
select * from p1;

SELECT REGEXP_SUBSTR(email.id, p1.code), p1.code FROM email, p1 ORDER BY p1.num;
SELECT REGEXP_SUBSTR(email.id, p1.code, p1.pos), p1.code, p1.pos FROM email, p1 ORDER BY p1.num;
SELECT REGEXP_SUBSTR(email.id, p1.code, p1.pos, p1.occ), p1.code, p1.pos, p1.occ FROM email, p1 ORDER BY p1.num;
SELECT REGEXP_SUBSTR(email.id, p1.code, p1.pos, p1.occ, p1.match_type), p1.code, p1.pos, p1.occ, p1.match_type FROM email, p1 ORDER BY p1.num;

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

SELECT DISTINCT REGEXP_SUBSTR(name, '[[:alpha:]]+', 1, 1) AS first_name FROM athlete ORDER BY 1;
DROP TABLE IF EXISTS first_name_store;
CREATE TABLE first_name_store (first_name VARCHAR) AS SELECT DISTINCT REGEXP_SUBSTR(name, '[[:alpha:]]+', 1, 1) AS first_name FROM athlete;
SELECT * FROM first_name_store;

DROP TABLE IF EXISTS first_name_store;
CREATE TABLE first_name_store ( first_name VARCHAR );
INSERT INTO first_name_store SELECT DISTINCT REGEXP_SUBSTR(name, '[[:alpha:]]+', 1, 1) AS first_name from athlete;
SELECT * FROM first_name_store;

DROP TABLE IF EXISTS first_name_store;
DROP TABLE IF EXISTS athlete;
DROP TABLE IF EXISTS email;
DROP TABLE IF EXISTS p1;

