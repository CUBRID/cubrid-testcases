drop table if exists test1,foo;
CREATE TABLE test1 (
    id    int  auto_increment primary key
);

INSERT INTO test1  VALUES (null), (null), (null), (null);

create table foo as
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , ROW_NUMBER() OVER (ORDER BY id2) AS n
  FROM cte1 AS t order by 1,2,3;

insert into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3;

select * from foo order by 1,2,3;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
delete from foo where (select count(id) from (SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3) as x)=(select count(*) from cte1);

select * from foo order by 1,2,3;


WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
update foo set foo.n=foo.n+10 where (select count(*) from (SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3) as x )=(select count(*) from cte1);

select * from foo order by 1,2,3;

drop table foo;
create table foo as
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as
(
SELECT t.*
     , ROW_NUMBER() OVER (ORDER BY id2) AS n
  FROM cte1 AS t order by 1,2,3
)select * from cte2 ;

insert into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as
(
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3
) select * from cte2;

select * from foo order by 1,2,3;

alter table foo change column id id int unique;
replace into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as
(
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3
) select * from cte2;

select * from foo order by 1,2,3;


WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as
(
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3
) delete foo from foo,cte2 where foo.id=cte2.id and foo.id2=cte2.id2 and foo.n=cte2.n;

select * from foo order by 1,2,3;


WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as
(
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t order by 1,2,3
) update foo,cte2 set foo.n=foo.n+100 where foo.id=cte2.id and foo.id2=cte2.id2 and foo.n=cte2.n;

select * from foo order by 1,2,3;

drop table if exists foo,test1;

