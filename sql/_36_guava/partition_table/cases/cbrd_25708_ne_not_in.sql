/**
 *  This test case verifies CBRD-25708 : Enable partition pruning when the partition key is a function expression and the WHERE clause uses the original column
 *  This test focuses on inequality-based filters: != and NOT IN
 */

DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS to_days_tbl;
DROP TABLE IF EXISTS unix_timestamp_tbl;
DROP TABLE IF EXISTS add_tbl;
DROP TABLE IF EXISTS sub_tbl;
DROP TABLE IF EXISTS mul_tbl;
DROP TABLE IF EXISTS div_tbl;
DROP TABLE IF EXISTS abs_tbl;
DROP TABLE IF EXISTS ceil_tbl;
DROP TABLE IF EXISTS datediff_tbl;
DROP TABLE IF EXISTS day_tbl;
DROP TABLE IF EXISTS dayofweek_tbl;
DROP TABLE IF EXISTS dayofyear_tbl;
DROP TABLE IF EXISTS extract_tbl;
DROP TABLE IF EXISTS floor_tbl;
DROP TABLE IF EXISTS hour_tbl;
DROP TABLE IF EXISTS second_tbl;
DROP TABLE IF EXISTS minute_tbl;
DROP TABLE IF EXISTS mod_tbl;
DROP TABLE IF EXISTS month_tbl;
DROP TABLE IF EXISTS quarter_tbl;
DROP TABLE IF EXISTS time_to_sec_tbl;
DROP TABLE IF EXISTS weekday_tbl;

set trace on;

CREATE TABLE year_tbl(col DATETIME) PARTITION BY LIST (YEAR(col)) (PARTITION p_value VALUES IN (2024), PARTITION p_null VALUES IN (NULL));
INSERT INTO year_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('1. YEAR, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col != '2024-01-01 23:23:59';
show trace;

evaluate concat('2. YEAR, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col NOT IN ('2024-01-01 23:23:59');
show trace;


CREATE TABLE to_days_tbl(col DATETIME) PARTITION BY LIST (TO_DAYS(col)) (PARTITION p_value VALUES IN (739251), PARTITION p_null VALUES IN (NULL));
INSERT INTO to_days_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('3. TO_DAYS, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col != '2024-01-01 23:23:59';
show trace;

evaluate concat('4. TO_DAYS, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col NOT IN ('2024-01-01 23:23:59');
show trace;


CREATE TABLE unix_timestamp_tbl(col DATETIME) PARTITION BY LIST (UNIX_TIMESTAMP(col)) (PARTITION p_value VALUES IN (1704119039), PARTITION p_null VALUES IN (NULL));
INSERT INTO unix_timestamp_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('5. UNIX_TIMESTAMP, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col != '2024-01-01 23:23:59';
show trace;

evaluate concat('6. UNIX_TIMESTAMP, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col NOT IN ('2024-01-01 23:23:59');
show trace;


CREATE TABLE add_tbl(col INT) PARTITION BY LIST (col + 3) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO add_tbl VALUES(7);

evaluate concat('7. ADD, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col != 7;
show trace;

evaluate concat('8. ADD, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col NOT IN (7);
show trace;


CREATE TABLE sub_tbl(col INT) PARTITION BY LIST (col - 3) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO sub_tbl VALUES(13);

evaluate concat('9. SUB, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col != 13;
show trace;

evaluate concat('10. SUB, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col NOT IN (13);
show trace;


CREATE TABLE mul_tbl(col INT) PARTITION BY LIST (col * 2) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO mul_tbl VALUES(5);

evaluate concat('11. MUL, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col != 5;
show trace;

evaluate concat('12. MUL, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col NOT IN (5);
show trace;


CREATE TABLE div_tbl(col INT) PARTITION BY LIST (col / 2) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO div_tbl VALUES(20);

evaluate concat('13. DIV, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col != 20;
show trace;

evaluate concat('14. DIV, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col NOT IN (20);
show trace;


CREATE TABLE abs_tbl(col INT) PARTITION BY LIST(ABS(col)) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO abs_tbl VALUES(-10);

evaluate concat('15. ABS, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col != -10;
show trace;

evaluate concat('16. ABS, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col NOT IN (-10);
show trace;


CREATE TABLE ceil_tbl(col INT) PARTITION BY LIST(CEIL(col)) (PARTITION p_value VALUES IN (11), PARTITION p_null VALUES IN (NULL));
INSERT INTO ceil_tbl VALUES(11);

evaluate concat('17. CEIL, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col != 11;
show trace;

evaluate concat('18. CEIL, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col NOT IN (11);
show trace;


CREATE TABLE datediff_tbl(col DATETIME) PARTITION BY LIST (DATEDIFF(col, '2000-01-01')) (PARTITION p_value VALUES IN (8766), PARTITION p_null VALUES IN (NULL));
INSERT INTO datediff_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('19. DATEDIFF, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('20. DATEDIFF, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE day_tbl(col DATETIME) PARTITION BY LIST (DAY(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO day_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('21. DAY, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('22. DAY, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE dayofweek_tbl(col DATETIME) PARTITION BY LIST (DAYOFWEEK(col)) (PARTITION p_value VALUES IN (2), PARTITION p_null VALUES IN (NULL));
INSERT INTO dayofweek_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('23. DAYOFWEEK, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('24. DAYOFWEEK, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE dayofyear_tbl(col DATETIME) PARTITION BY LIST (DAYOFYEAR(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO dayofyear_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('25. DAYOFYEAR, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('26. DAYOFYEAR, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE extract_tbl(col DATETIME) PARTITION BY LIST (EXTRACT(MONTH FROM col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO extract_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('27. EXTRACT, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('28. EXTRACT, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE floor_tbl(col INT) PARTITION BY LIST(FLOOR(col)) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO floor_tbl VALUES(10);

evaluate concat('29. FLOOR, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col != 10;
show trace;

evaluate concat('30. FLOOR, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col NOT IN (10);
show trace;


CREATE TABLE hour_tbl(col DATETIME) PARTITION BY LIST (HOUR(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO hour_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('31. HOUR, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('32. HOUR, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE second_tbl(col DATETIME) PARTITION BY LIST (SECOND(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO second_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('33. SECOND, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('34. SECOND, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE minute_tbl(col DATETIME) PARTITION BY LIST (MINUTE(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO minute_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('35. MINUTE, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('36. MINUTE, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE mod_tbl(col INT) PARTITION BY LIST(MOD(col, 3)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO mod_tbl VALUES(10);

evaluate concat('37. MOD, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col != 10;
show trace;

evaluate concat('38. MOD, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col NOT IN (10);
show trace;


CREATE TABLE month_tbl(col DATETIME) PARTITION BY LIST (MONTH(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO month_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('39. MONTH, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('40. MONTH, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE quarter_tbl(col DATETIME) PARTITION BY LIST (QUARTER(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO quarter_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('41. QUARTER, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col != '2024-01-01 00:00:00';
show trace;

evaluate concat('42. QUARTER, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col NOT IN ('2024-01-01 00:00:00');
show trace;


CREATE TABLE time_to_sec_tbl(col DATETIME) PARTITION BY LIST (TIME_TO_SEC(col)) (PARTITION p_value VALUES IN (84239), PARTITION p_null VALUES IN (NULL));
INSERT INTO time_to_sec_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('43. TIME_TO_SEC, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col != '2024-01-01 23:23:59';
show trace;

evaluate concat('44. TIME_TO_SEC, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col NOT IN ('2024-01-01 23:23:59');
show trace;


CREATE TABLE weekday_tbl(col DATETIME) PARTITION BY LIST (WEEKDAY(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO weekday_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('45. WEEKDAY, != (no pruning)');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col != '2024-01-01 23:23:59';
show trace;

evaluate concat('46. WEEKDAY, NOT IN (no pruning)');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col NOT IN ('2024-01-01 23:23:59');
show trace;

set trace off;

DROP TABLE IF EXISTS year_tbl;
DROP TABLE IF EXISTS to_days_tbl;
DROP TABLE IF EXISTS unix_timestamp_tbl;
DROP TABLE IF EXISTS add_tbl;
DROP TABLE IF EXISTS sub_tbl;
DROP TABLE IF EXISTS mul_tbl;
DROP TABLE IF EXISTS div_tbl;
DROP TABLE IF EXISTS abs_tbl;
DROP TABLE IF EXISTS ceil_tbl;
DROP TABLE IF EXISTS datediff_tbl;
DROP TABLE IF EXISTS day_tbl;
DROP TABLE IF EXISTS dayofweek_tbl;
DROP TABLE IF EXISTS dayofyear_tbl;
DROP TABLE IF EXISTS extract_tbl;
DROP TABLE IF EXISTS floor_tbl;
DROP TABLE IF EXISTS hour_tbl;
DROP TABLE IF EXISTS second_tbl;
DROP TABLE IF EXISTS minute_tbl;
DROP TABLE IF EXISTS mod_tbl;
DROP TABLE IF EXISTS month_tbl;
DROP TABLE IF EXISTS quarter_tbl;
DROP TABLE IF EXISTS time_to_sec_tbl;
DROP TABLE IF EXISTS weekday_tbl;
