drop if exists case_tbl;
CREATE TABLE case_tbl( a INT);
INSERT INTO case_tbl VALUES (1);
INSERT INTO case_tbl VALUES (2);
INSERT INTO case_tbl VALUES (3);
INSERT INTO case_tbl VALUES (NULL);

--case operation with a search when clause
SELECT a,
       CASE WHEN a in (with cte(a) as(select * from case_tbl where a=1) select * from cte) THEN 'one'
            WHEN a in (with cte(a) as(select * from case_tbl where a=2) select * from cte) THEN 'two'
            ELSE 'other'
       END
FROM case_tbl
order by 1,2;

--case operation with a simple when clause
SELECT a,
       CASE a WHEN (with cte(a) as(select * from case_tbl where a=1) select * from cte) THEN 'one'
              WHEN (with cte(a) as(select * from case_tbl where a=2) select * from cte) THEN 'two'
              ELSE 'other'
       END
FROM case_tbl
order by 1,2;

--an error occurs when result types are not convertible
SELECT a,
       CASE a WHEN (with cte(a) as(select * from case_tbl where a=1) select * from cte) THEN 'one'
              WHEN (with cte(a) as(select * from case_tbl where a=2) select * from cte) THEN 'two'
              ELSE 1.2345
       END
FROM case_tbl
order by 1,2;

--result types are converted to a single type containing all of significant figures
SELECT a,
       CASE a WHEN (with cte(a) as(select * from case_tbl where a=1) select * from cte) THEN 1
              WHEN (with cte(a) as(select * from case_tbl where a=2) select * from cte) THEN 1.2345
              ELSE 1.234567890
       END
FROM case_tbl
order by 1,2;
drop table case_tbl;
