drop table if exists case_tbl,foo;
CREATE TABLE case_tbl( a INT);
INSERT INTO case_tbl VALUES (1);
INSERT INTO case_tbl VALUES (2);
INSERT INTO case_tbl VALUES (3);
INSERT INTO case_tbl VALUES (NULL);

create table foo as
with cte(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN 'one'
            WHEN a=2 THEN 'two'
            ELSE 'other'
       END
FROM case_tbl
)select * from cte;

insert into foo
with cte(a,case_v) as
(
SELECT a,
       CASE a WHEN 1 THEN 'one'
              WHEN 2 THEN 'two'
              ELSE 'other'
       END
FROM case_tbl
)select * from cte;

replace into foo
with cte(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN 1
            WHEN a=2 THEN 1.2345
            ELSE 1.234567890
       END
FROM case_tbl
)select * from cte;

replace into foo
with cte(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN 'one'
            WHEN a=2 THEN 'two'
            ELSE 1.2345
       END
FROM case_tbl
)select * from cte;


select * from foo order by 1,2;

--update
with cte1(a,case_v) as
(
SELECT a,
       CASE a WHEN 1 THEN '1-one'
              WHEN 2 THEN '2-two'
              ELSE 'unknown-other'
       END
FROM case_tbl
),
 cte2(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN -1
            WHEN a=2 THEN -1.2345
            ELSE -1.234567890
       END
FROM case_tbl
) update foo inner join cte1 on foo.a=cte1.a  set foo.case_v=cte1.case_v where exists(
select * from cte2
);

select * from foo order by 1,2;


--delete
with cte1(a,case_v) as
(
SELECT a,
       CASE a WHEN 1 THEN '1-one'
              WHEN 2 THEN '2-two'
              ELSE 'unknown-other'
       END
FROM case_tbl
),
 cte2(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN -1
            WHEN a=2 THEN -1.2345
            ELSE -1.234567890
       END
FROM case_tbl
) delete foo,case_tbl from cte1 inner join foo on foo.case_v=cte1.case_v inner join case_tbl on foo.a=case_tbl.a;

select * from foo order by 1,2;
select * from case_tbl;

with cte1(a,case_v) as
(
SELECT a,
       CASE a WHEN 1 THEN 'one'
              WHEN 2 THEN 'two'
              ELSE 'other'
       END
FROM case_tbl
),
cte2(a,case_v) as
(
SELECT a,
       CASE WHEN a=1 THEN 1
            WHEN a=2 THEN 1.2345
            ELSE 1.234567890
       END
FROM case_tbl
) delete from foo where case_v in (select case_v from cte1)
or case_v in (select case_v from cte2);

select * from foo order by 1,2;


drop table if exists case_tbl,foo;
