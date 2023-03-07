-- This is a test case for aggregation function 'RANK', 'ROW_NUMBER'.

DROP TABLE IF EXISTS t1;

CREATE OR REPLACE FUNCTION fc1(i string) RETURN string as language java name 'SpTest7.typeteststring(java.lang.String) return java.lang.String';
CREATE TABLE t1 (host_year int, nation_code char(3), gold int , silver int, bronze int);
INSERT INTO t1 VALUES
(1988,'URS',55,31,46),
(1988,'GDR',37,35,30),
(1988,'USA',36,31,27),
(1988,'KOR',12,10,11),
(1988,'HUN',11,6,6),
(1992,'EUN',45,38,29),
(1992,'USA',37,34,37),
(1992,'GER',33,21,28),
(1992,'CHN',16,22,16),
(1992,'CUB',14,6,11),
(1996,'USA',44,32,25),
(1996,'RUS',26,21,16),
(1996,'GER',20,18,27),
(1996,'CHN',16,22,12),
(1996,'FRA',15,7,15);

--test 'RANK()'
SELECT host_year, nation_code, gold,
RANK() OVER (PARTITION BY fc1(host_year) ORDER BY gold DESC) AS g_rank
FROM t1;

SELECT host_year, nation_code, gold,
RANK() OVER (PARTITION BY host_year ORDER BY fc1(gold) DESC) AS g_rank
FROM t1;

--test 'ROW_NUMBER()'
SELECT host_year, nation_code, gold,
ROW_NUMBER() OVER (PARTITION BY fc1(host_year) ORDER BY gold DESC) AS r_num
FROM t1;

SELECT host_year, nation_code, gold,
ROW_NUMBER() OVER (PARTITION BY host_year ORDER BY fc1(gold) DESC) AS r_num
FROM t1;

DROP FUNCTION fc1;
DROP TABLE t1;

