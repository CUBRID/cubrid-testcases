--+ holdcas on;
drop table if exists sales_mon_tbl;
CREATE TABLE sales_mon_tbl (
    yyyy INT,
    mm INT,
    sales_sum INT
);
INSERT INTO sales_mon_tbl VALUES
    (2000, 1, 1000), (2000, 2, 770), (2000, 3, 630), (2000, 4, 890),
    (2001, 1, 1010), (2001, 2, 700), (2001, 3, 600), (2001, 4, 900),
    (2002, 1, 980), (2002, 2, 750), (2002, 3, 730), (2002, 4, 980);

SELECT yyyy, mm, sales_sum, 
RANK() OVER (PARTITION BY yyyy ORDER BY sales_sum desc) AS rnk,
RANK() OVER (PARTITION BY yyyy ORDER BY sales_sum ASC, mm desc) AS rnk1,
RANK() OVER (PARTITION BY yyyy ORDER BY mm ) AS rnk2,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy asc, mm) AS a_sum,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy, mm desc) AS a_sum1,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy desc, mm desc) AS a_sum2
FROM sales_mon_tbl order by yyyy, mm, sales_sum;
drop table if exists sales_mon_tbl;

drop table if exists scores;
CREATE TABLE scores(id INT PRIMARY KEY AUTO_INCREMENT, math INT, english INT, pe CHAR, grade INT);
INSERT INTO scores(math, english, pe, grade)
VALUES(60, 70, 'A', 1), (95, 90, 'A', 2),
 (60, 70, 'A', 1),  (85, 95, 'B', 2),
 (60, 80, 'A', 1),  (95, 90, 'A', 2),
 (70, 70, 'A', 1) , (75, 85, 'D', 2),
 (80, 70, 'C', 1) , (75, 70, 'C', 2),
 (70, 80, 'C', 1),  (65, 95, 'A', 2),
 (75, 90, 'B', 1),  (65, 95, 'A', 2);
 
SELECT id, math, english, pe, grade, 
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC) AS d_rank,
COUNT(*) OVER (ORDER BY grade) co,
CUME_DIST() OVER(ORDER BY math, english, pe) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe) AS cume_dist2,
PERCENT_RANK() OVER(ORDER BY math, english, pe) AS percent_rank,
PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe) AS percent_rank2
FROM scores ORDER BY id;

SELECT id, math, english, pe, grade, 
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY math desc) OVER (PARTITION BY grade) AS pdisc,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY math) OVER (PARTITION BY grade) AS pcont
FROM scores ORDER BY id;
  
SELECT id, math, grade, 
RANK() OVER (PARTITION BY grade ORDER BY math DESC) AS g_rank,
ROW_NUMBER() OVER (PARTITION BY grade ORDER BY math DESC) AS r_num,
STDDEV_POP(math) OVER(PARTITION BY grade) std_pop,
STDDEV_SAMP(math) OVER(PARTITION BY grade) std_samp,
SUM(math) OVER (PARTITION BY grade ORDER BY id) sum_gold1,
SUM(math) OVER (PARTITION BY grade ) sum_gold2,
VAR_POP(math) OVER(PARTITION BY grade) v_pop,
VAR_SAMP(math) OVER(PARTITION BY grade) v_samp
FROM scores ORDER BY id;

SELECT id, grade, math,
FIRST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math) AS FIRST_val1,
FIRST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST) AS FIRST_val2,
FIRST_VALUE(math) IGNORE NULLS OVER(PARTITION BY grade ORDER BY grade, math) AS FIRST_val3,
LAST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math) AS LAST_val1,
LAST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST) AS LAST_val2,
NTH_VALUE(math, 2) IGNORE NULLS OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST) AS NTH_val1,
NTH_VALUE(math,2) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST) AS NTH_val2,
LAG (math, 1, 10000) OVER (ORDER BY grade, math) prev_math,
LEAD (math, 1,9999) OVER (ORDER BY grade, math) next_math,
MAX(math) OVER (PARTITION BY grade) mx_math,
MEDIAN(math) OVER (PARTITION BY grade) mdn_math,
MIN(math) OVER (PARTITION BY grade) mn_math,
NTILE(5) OVER (ORDER BY grade, math DESC) grade
FROM scores order by id;

drop table if exists scores;


--+ holdcas off;
