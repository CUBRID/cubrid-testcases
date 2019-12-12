drop if exists case_tbl;
CREATE TABLE case_tbl( a INT);
INSERT INTO case_tbl VALUES (1);
INSERT INTO case_tbl VALUES (2);
INSERT INTO case_tbl VALUES (3),(9),(11);
INSERT INTO case_tbl VALUES (NULL);

SELECT a
FROM case_tbl
where a between 
(with  recursive cte(a) as( select 1 union all select a+1 from cte where a<10)select * from cte order by 1 limit 1) 
and 
(with  recursive cte(a) as( select 1 union all select a+1 from cte where a<10) select * from cte order by 1 desc limit 1) order by 1;

drop table case_tbl;
