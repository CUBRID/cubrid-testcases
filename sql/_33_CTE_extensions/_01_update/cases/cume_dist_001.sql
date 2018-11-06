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

    drop table if exists t1;
    create table t1(a bigint,b int,c bigint,d int,e int,f int,g bigint,h bigint,i bigint)
    insert into t1(a) values(1); 

with cte1(a,b,c,d,e,f,g,h,i) as
(
SELECT yyyy, mm, sales_sum, 
RANK() OVER (PARTITION BY yyyy ORDER BY sales_sum desc) AS rnk,
RANK() OVER (PARTITION BY yyyy ORDER BY sales_sum ASC, mm desc) AS rnk1,
RANK() OVER (PARTITION BY yyyy ORDER BY mm ) AS rnk2,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy asc, mm) AS a_sum,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy, mm desc) AS a_sum1,
SUM(sales_sum) OVER (PARTITION BY yyyy ORDER BY yyyy desc, mm desc) AS a_sum2
FROM sales_mon_tbl order by yyyy, mm, sales_sum
) update t1 set a=(select a from cte1 limit 1),
b=(select b from cte1 limit 1),
c=(select c from cte1 limit 1),
d=(select d from cte1 limit 1) ,
e=(select e from cte1 limit 1),
f=(select f from cte1 limit 1),
g=(select g from cte1 limit 1), 
h=(select h from cte1 limit 1),
i=(select i from cte1 limit 1);
select * from t1;



drop table if exists sales_mon_tbl;

drop table if exists scores;
CREATE TABLE scores(id INT PRIMARY KEY auto_increment , math INT, english INT, pe CHAR, grade INT);
INSERT INTO scores(math, english, pe, grade)
VALUES(60, 70, 'A', 1), (95, 90, 'A', 2),
  (75, 90, 'B', 1),(85, 95, 'B', 2),
 (80, 70, 'C', 1) , (75, 70, 'C', 2);
 

SELECT id, math, english, pe, grade,
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC,id) AS d_rank,
COUNT(*) OVER (ORDER BY grade,id) co,
CUME_DIST() OVER(ORDER BY math, english, pe,id) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS cume_dist2,
PERCENT_RANK() OVER(ORDER BY math, english, pe,id) AS percent_rank,
PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS percent_rank2
FROM scores ORDER BY id;


drop view if exists v1;
create view v1 as select * from  scores;

drop table if exists A;
create table A as select * from scores;
alter table A add column des varchar(50);

with cte1 as
(
SELECT id, math, english, pe, grade,
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC,id) AS d_rank,
COUNT(*) OVER (ORDER BY grade,id) co,
CUME_DIST() OVER(ORDER BY math, english, pe,id) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS cume_dist2
FROM v1 ORDER BY id
) update A inner join cte1 on A.id=cte1.id and A.grade=cte1.grade set A.des='math high' where A.math > cte1.avg_math ;

select * from A order by 1,2,3,4,5;

with cte1 as
(
SELECT id, math, english, pe, grade,
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC,id) AS d_rank,
COUNT(*) OVER (ORDER BY grade,id) co,
CUME_DIST() OVER(ORDER BY math, english, pe,id) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS cume_dist2,
PERCENT_RANK() OVER(ORDER BY math, english, pe,id) AS percent_rank,
PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS percent_rank2
FROM v1 ORDER BY id
) update A inner join cte1 on A.id=cte1.id and A.grade=cte1.grade set A.des='math high' where A.math > cte1.avg_math ;

select * from A order by 1,2,3,4,5;

select count(id) from v1;

create or replace view v1 as select * from scores;

with cte1 as
(
SELECT id, math, english, pe, grade, 
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC,id) AS d_rank,
COUNT(*) OVER (ORDER BY grade,id) co,
CUME_DIST() OVER(ORDER BY math, english, pe,id) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS cume_dist2,
PERCENT_RANK() OVER(ORDER BY math, english, pe,id) AS percent_rank,
PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS percent_rank2
FROM scores ORDER BY id
) update v1 inner join cte1 on v1.id=cte1.id and v1.grade=cte1.grade set v1.english=cte1.english where v1.math<cte1.avg_math;

create or replace view v1 as select * from scores;
with cte1 as
(
SELECT id, math, english, pe, grade,
AVG(math) OVER (PARTITION BY grade ORDER BY id) avg_math,
AVG(english) OVER (PARTITION BY grade) avg_english,
DENSE_RANK() OVER (PARTITION BY grade ORDER BY pe DESC,id) AS d_rank,
COUNT(*) OVER (ORDER BY grade,id) co,
CUME_DIST() OVER(ORDER BY math, english, pe,id) AS cume_dist1,
CUME_DIST() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS cume_dist2,
PERCENT_RANK() OVER(ORDER BY math, english, pe,id) AS percent_rank,
PERCENT_RANK() OVER(PARTITION BY grade ORDER BY math, english, pe,id) AS percent_rank2
FROM scores ORDER BY id
) update A inner join cte1 on A.id=cte1.id and A.grade=cte1.grade set A.english=cte1.english where A.math<cte1.avg_math;


with cte1 as
(
SELECT id, math, english, pe, grade, 
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY math desc) OVER (PARTITION BY grade) AS pdisc,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY math) OVER (PARTITION BY grade) AS pcont
FROM scores ORDER BY id
) update v1,A set v1.english = A.english  where v1.english >A.english;

with cte1 as
(
SELECT id, math, english, pe, grade,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY math desc) OVER (PARTITION BY grade) AS pdisc,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY math) OVER (PARTITION BY grade) AS pcont
FROM scores ORDER BY id
) update v1,scores set v1.english = scores.english  where v1.english <=scores.english;

 
with cte1 as
(
SELECT id, math, english, pe, grade,
PERCENTILE_DISC(0.5) WITHIN GROUP(ORDER BY math desc) OVER (PARTITION BY grade) AS pdisc,
PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY math) OVER (PARTITION BY grade) AS pcont
FROM scores ORDER BY id
) update v1,cte1 set v1.english = cte1.english  where v1.english <=cte1.english;

with cte1 as
(
SELECT id, math, grade, 
RANK() OVER (PARTITION BY grade ORDER BY math DESC,id) AS g_rank,
ROW_NUMBER() OVER (PARTITION BY grade ORDER BY math DESC,id) AS r_num,
STDDEV_POP(math) OVER(PARTITION BY grade) std_pop,
STDDEV_SAMP(math) OVER(PARTITION BY grade) std_samp,
SUM(math) OVER (PARTITION BY grade ORDER BY id) sum_gold1,
SUM(math) OVER (PARTITION BY grade ) sum_gold2,
VAR_POP(math) OVER(PARTITION BY grade) v_pop,
VAR_SAMP(math) OVER(PARTITION BY grade) v_samp
FROM scores ORDER BY id
) update v1,cte1 set v1.math = 70 
where (select g_rank from cte1 order by 1 desc limit 1) >5;

with cte1 as
(
SELECT id, grade, math,
FIRST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math,id) AS FIRST_val1,
FIRST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST,id) AS FIRST_val2,
FIRST_VALUE(math) IGNORE NULLS OVER(PARTITION BY grade ORDER BY grade, math,id) AS FIRST_val3,
LAST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math,id) AS LAST_val1,
LAST_VALUE(math) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST,id) AS LAST_val2,
NTH_VALUE(math, 2) IGNORE NULLS OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST,id) AS NTH_val1,
NTH_VALUE(math,2) OVER(PARTITION BY grade ORDER BY grade, math NULLS FIRST,id) AS NTH_val2,
LAG (math, 1, 10000) OVER (ORDER BY grade, math,id) prev_math,
LEAD (math, 1,9999) OVER (ORDER BY grade, math,id) next_math,
MAX(math) OVER (PARTITION BY grade) mx_math,
MEDIAN(math) OVER (PARTITION BY grade) mdn_math,
MIN(math) OVER (PARTITION BY grade) mn_math,
NTILE(5) OVER (ORDER BY grade, math DESC,id) grade
FROM scores order by id
) update v2 set id=12 where id=2;  

drop table if exists scores;


--+ holdcas off;
