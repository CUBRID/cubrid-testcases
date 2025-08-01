/**
 *  This test case verifies CBRD-25708 : Enable partition pruning when the partition key is a function expression and the WHERE clause uses the original column
 *  This test covers equality-based conditions: = and IN
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

evaluate concat('1. YEAR, =');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col = '2024-01-01 23:23:59';
show trace;

evaluate concat('2. YEAR, IN');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col IN ('2024-01-01 23:23:59');
show trace;

evaluate concat('3. YEAR, ALSM');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col = some{'2024-01-01 23:23:59'};
show trace;

evaluate concat('4. YEAR, IS NULL');
SELECT /*+ recompile */ count(*) FROM year_tbl WHERE col IS NULL;
show trace;


CREATE TABLE to_days_tbl(col DATETIME) PARTITION BY LIST (TO_DAYS(col)) (PARTITION p_value VALUES IN (739251), PARTITION p_null VALUES IN (NULL));
INSERT INTO to_days_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('5. TO_DAYS, =');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col = '2024-01-01 23:23:59';
show trace;

evaluate concat('6. TO_DAYS, IN');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col IN ('2024-01-01 23:23:59');
show trace;

evaluate concat('7. TO_DAYS, ALSM');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col = some{'2024-01-01 23:23:59'};
show trace;

evaluate concat('8. TO_DAYS, IS NULL');
SELECT /*+ recompile */ count(*) FROM to_days_tbl WHERE col IS NULL;
show trace;


CREATE TABLE unix_timestamp_tbl(col DATETIME) PARTITION BY LIST (UNIX_TIMESTAMP(col)) (PARTITION p_value VALUES IN (1704119039), PARTITION p_null VALUES IN (NULL));
INSERT INTO unix_timestamp_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('9. UNIX_TIMESTAMP, =');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col = '2024-01-01 23:23:59';
show trace;

evaluate concat('10. UNIX_TIMESTAMP, IN');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col IN ('2024-01-01 23:23:59');
show trace;

evaluate concat('11. UNIX_TIMESTAMP, ALSM');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col = some{'2024-01-01 23:23:59'};
show trace;

evaluate concat('12. UNIX_TIMESTAMP, IS NULL');
SELECT /*+ recompile */ count(*) FROM unix_timestamp_tbl WHERE col IS NULL;
show trace;


CREATE TABLE add_tbl(col INT) PARTITION BY LIST (col + 3) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO add_tbl VALUES(7);

evaluate concat('13. ADD, =');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col = 7;
show trace;

evaluate concat('14. ADD, IN');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col IN (7);
show trace;

evaluate concat('15. ADD, ALSM');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col = some{7};
show trace;

evaluate concat('16. ADD, IS NULL');
SELECT /*+ recompile */ count(*) FROM add_tbl WHERE col IS NULL;
show trace;

CREATE TABLE sub_tbl(col INT) PARTITION BY LIST (col - 3) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO sub_tbl VALUES(13);

evaluate concat('17. SUB, =');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col = 13;
show trace;

evaluate concat('18. SUB, IN');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col IN (13);
show trace;

evaluate concat('19. SUB, ALSM');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col = some{13};
show trace;

evaluate concat('20. SUB, IS NULL');
SELECT /*+ recompile */ count(*) FROM sub_tbl WHERE col IS NULL;
show trace;

CREATE TABLE mul_tbl(col INT) PARTITION BY LIST (col * 2) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO mul_tbl VALUES(5);

evaluate concat('21. MUL, =');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col = 5;
show trace;

evaluate concat('22. MUL, IN');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col IN (5);
show trace;

evaluate concat('23. MUL, ALSM');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col = some{5};
show trace;

evaluate concat('24. MUL, IS NULL');
SELECT /*+ recompile */ count(*) FROM mul_tbl WHERE col IS NULL;
show trace;

CREATE TABLE div_tbl(col INT) PARTITION BY LIST (col / 2) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO div_tbl VALUES(20);

evaluate concat('25. DIV, =');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col = 20;
show trace;

evaluate concat('26. DIV, IN');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col IN (20);
show trace;

evaluate concat('27. DIV, ALSM');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col = some{20};
show trace;

evaluate concat('28. DIV, IS NULL');
SELECT /*+ recompile */ count(*) FROM div_tbl WHERE col IS NULL;
show trace;

CREATE TABLE abs_tbl(col INT) PARTITION BY LIST(ABS(col)) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO abs_tbl VALUES(-10);

evaluate concat('29. ABS, =');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col = -10;
show trace;

evaluate concat('30. ABS, IN');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col IN (-10);
show trace;

evaluate concat('31. ABS, ALSM');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col = some{-10};
show trace;

evaluate concat('32. ABS, IS NULL');
SELECT /*+ recompile */ count(*) FROM abs_tbl WHERE col IS NULL;
show trace;

CREATE TABLE ceil_tbl(col INT) PARTITION BY LIST(CEIL(col)) (PARTITION p_value VALUES IN (11), PARTITION p_null VALUES IN (NULL));
INSERT INTO ceil_tbl VALUES(11);

evaluate concat('33. CEIL, =');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col = 11;
show trace;

evaluate concat('34. CEIL, IN');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col IN (11);
show trace;

evaluate concat('35. CEIL, ALSM');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col = some{11};
show trace;

evaluate concat('36. CEIL, IS NULL');
SELECT /*+ recompile */ count(*) FROM ceil_tbl WHERE col IS NULL;
show trace;

CREATE TABLE datediff_tbl(col DATETIME) PARTITION BY LIST (DATEDIFF(col, '2000-01-01')) (PARTITION p_value VALUES IN (8766), PARTITION p_null VALUES IN (NULL));
INSERT INTO datediff_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('37. DATEDIFF, =');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('38. DATEDIFF, IN');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('39. DATEDIFF, ALSM');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('40. DATEDIFF, IS NULL');
SELECT /*+ recompile */ count(*) FROM datediff_tbl WHERE col IS NULL;
show trace;

CREATE TABLE day_tbl(col DATETIME) PARTITION BY LIST (DAY(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO day_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('41. DAY, =');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('42. DAY, IN');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('43. DAY, ALSM');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('44. DAY, IS NULL');
SELECT /*+ recompile */ count(*) FROM day_tbl WHERE col IS NULL;
show trace;

CREATE TABLE dayofweek_tbl(col DATETIME) PARTITION BY LIST (DAYOFWEEK(col)) (PARTITION p_value VALUES IN (2), PARTITION p_null VALUES IN (NULL));
INSERT INTO dayofweek_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('45. DAYOFWEEK, =');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('46. DAYOFWEEK, IN');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('47. DAYOFWEEK, ALSM');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('48. DAYOFWEEK, IS NULL');
SELECT /*+ recompile */ count(*) FROM dayofweek_tbl WHERE col IS NULL;
show trace;

CREATE TABLE dayofyear_tbl(col DATETIME) PARTITION BY LIST (DAYOFYEAR(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO dayofyear_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('49. DAYOFYEAR, =');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('50. DAYOFYEAR, IN');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('51. DAYOFYEAR, ALSM');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('52. DAYOFYEAR, IS NULL');
SELECT /*+ recompile */ count(*) FROM dayofyear_tbl WHERE col IS NULL;
show trace;

CREATE TABLE extract_tbl(col DATETIME) PARTITION BY LIST (EXTRACT(MONTH FROM col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO extract_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('53. EXTRACT, =');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('54. EXTRACT, IN');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('55. EXTRACT, ALSM');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('56. EXTRACT, IS NULL');
SELECT /*+ recompile */ count(*) FROM extract_tbl WHERE col IS NULL;
show trace;

CREATE TABLE floor_tbl(col INT) PARTITION BY LIST(FLOOR(col)) (PARTITION p_value VALUES IN (10), PARTITION p_null VALUES IN (NULL));
INSERT INTO floor_tbl VALUES(10);

evaluate concat('57. FLOOR, =');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col = 10;
show trace;

evaluate concat('58. FLOOR, IN');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col IN (10);
show trace;

evaluate concat('59. FLOOR, ALSM');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col = some{10};
show trace;

evaluate concat('60. FLOOR, IS NULL');
SELECT /*+ recompile */ count(*) FROM floor_tbl WHERE col IS NULL;
show trace;

CREATE TABLE hour_tbl(col DATETIME) PARTITION BY LIST (HOUR(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO hour_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('61. HOUR, =');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('62. HOUR, IN');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('63. HOUR, ALSM');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('64. HOUR, IS NULL');
SELECT /*+ recompile */ count(*) FROM hour_tbl WHERE col IS NULL;
show trace;

CREATE TABLE second_tbl(col DATETIME) PARTITION BY LIST (SECOND(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO second_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('65. SECOND, =');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('66. SECOND, IN');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('67. SECOND, ALSM');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('68. SECOND, IS NULL');
SELECT /*+ recompile */ count(*) FROM second_tbl WHERE col IS NULL;
show trace;

CREATE TABLE minute_tbl(col DATETIME) PARTITION BY LIST (MINUTE(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO minute_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('69. MINUTE, =');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('70. MINUTE, IN');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('71. MINUTE, ALSM');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('72. MINUTE, IS NULL');
SELECT /*+ recompile */ count(*) FROM minute_tbl WHERE col IS NULL;
show trace;

CREATE TABLE mod_tbl(col INT) PARTITION BY LIST(MOD(col, 3)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO mod_tbl VALUES(10);

evaluate concat('73. MOD, =');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col = 10;
show trace;

evaluate concat('74. MOD, IN');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col IN (10);
show trace;

evaluate concat('75. MOD, ALSM');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col = some{10};
show trace;

evaluate concat('76. MOD, IS NULL');
SELECT /*+ recompile */ count(*) FROM mod_tbl WHERE col IS NULL;
show trace;

CREATE TABLE month_tbl(col DATETIME) PARTITION BY LIST (MONTH(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO month_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('77. MONTH, =');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('78. MONTH, IN');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('79. MONTH, ALSM');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('80. MONTH, IS NULL');
SELECT /*+ recompile */ count(*) FROM month_tbl WHERE col IS NULL;
show trace;

CREATE TABLE quarter_tbl(col DATETIME) PARTITION BY LIST (QUARTER(col)) (PARTITION p_value VALUES IN (1), PARTITION p_null VALUES IN (NULL));
INSERT INTO quarter_tbl VALUES('2024-01-01 00:00:00');

evaluate concat('81. QUARTER, =');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col = '2024-01-01 00:00:00';
show trace;

evaluate concat('82. QUARTER, IN');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col IN ('2024-01-01 00:00:00');
show trace;

evaluate concat('83. QUARTER, ALSM');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col = some{'2024-01-01 00:00:00'};
show trace;

evaluate concat('84. QUARTER, IS NULL');
SELECT /*+ recompile */ count(*) FROM quarter_tbl WHERE col IS NULL;
show trace;

CREATE TABLE time_to_sec_tbl(col DATETIME) PARTITION BY LIST (TIME_TO_SEC(col)) (PARTITION p_value VALUES IN (84239), PARTITION p_null VALUES IN (NULL));
INSERT INTO time_to_sec_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('85. TIME_TO_SEC, =');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col = '2024-01-01 23:23:59';
show trace;

evaluate concat('86. TIME_TO_SEC, IN');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col IN ('2024-01-01 23:23:59');
show trace;

evaluate concat('87. TIME_TO_SEC, ALSM');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col = some{'2024-01-01 23:23:59'};
show trace;

evaluate concat('88. TIME_TO_SEC, IS NULL');
SELECT /*+ recompile */ count(*) FROM time_to_sec_tbl WHERE col IS NULL;
show trace;

CREATE TABLE weekday_tbl(col DATETIME) PARTITION BY LIST (WEEKDAY(col)) (PARTITION p_value VALUES IN (0), PARTITION p_null VALUES IN (NULL));
INSERT INTO weekday_tbl VALUES('2024-01-01 23:23:59');

evaluate concat('89. WEEKDAY, =');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col = '2024-01-01 23:23:59';
show trace;

evaluate concat('90. WEEKDAY, IN');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col IN ('2024-01-01 23:23:59');
show trace;

evaluate concat('91. WEEKDAY, ALSM');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col = some{'2024-01-01 23:23:59'};
show trace;

evaluate concat('92. WEEKDAY, IS NULL');
SELECT /*+ recompile */ count(*) FROM weekday_tbl WHERE col IS NULL;
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

