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
--;lin on
SELECT REGEXP_SUBSTR(ip, '[^.]+', 1, 1) ip_1
, REGEXP_SUBSTR(ip, '[^.]+', 1, 2) ip_2
, REGEXP_SUBSTR(ip, '[^.]+', 1, 3) ip_3
, REGEXP_SUBSTR(ip, '[^.]+', 1, 4) ip_4
FROM (SELECT '10.100.10.1' ip
UNION ALL SELECT '10.100.1.10'
UNION ALL SELECT '100.10.1.20'
UNION ALL SELECT '2.10.1.140') t
ORDER BY ip_1, ip_2, ip_3, ip_4;

DROP TABLE IF EXISTS athlete;
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
SELECT DISTINCT REGEXP_SUBSTR (name, '[[:alpha:]]+', 1, 1) AS first_name FROM athlete ORDER BY 1;

CREATE TABLE first_name_store (first_name VARCHAR) AS SELECT DISTINCT REGEXP_SUBSTR(name, '[[:alpha:]]+', 1, 1) AS first_name FROM athlete;
SELECT * FROM first_name_store;
DROP TABLE IF EXISTS first_name_store;

CREATE TABLE first_name_store ( first_name VARCHAR );
INSERT INTO first_name_store SELECT DISTINCT REGEXP_SUBSTR(name, '[[:alpha:]]+', 1, 1) AS first_name from athlete;
SELECT * FROM first_name_store;
DROP TABLE first_name_store;

SELECT BIT_LENGTH(REGEXP_SUBSTR('Samseong-ro 86-gil, Gangnam-gu, Seoul', '\w+\-GU', 1, 1, 'i'));

WITH V_TEST AS (SELECT 'hello@cubrid.com' AS EMAIL)
SELECT REGEXP_SUBSTR(EMAIL, '[^@]+', 1, 1) AS "id", REGEXP_SUBSTR(EMAIL, '[^@]+', 1, 2) AS "domain" FROM V_TEST;
