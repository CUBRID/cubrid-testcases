drop table if exists test1;
CREATE TABLE test1 (
    id    int  auto_increment primary key
);

INSERT INTO test1  VALUES (null), (null), (null), (null);


drop table if exists foo;
create table foo as
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     ,  INST_NUM() AS n
  FROM cte1 AS t
;

replace into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , INST_NUM()  AS n
  FROM cte1 AS t;

select * from foo order by 1,2,3;

replace into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , INST_NUM()  AS n
  FROM cte1 as t) select * from cte2
;
select * from foo order by 1,2,3;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , INST_NUM()  AS n
  FROM cte1 as t) delete from foo where n in (
SELECT INST_NUM()  AS n
  FROM cte1 )
;
select * from foo order by 1,2,3;


replace into foo
WITH cte1 AS (
SELECT t.*
, t.id + 5 AS id2
FROM test1 AS t
)
SELECT t.*
, INST_NUM()  AS n
FROM cte1 AS t;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , INST_NUM()  AS n
  FROM cte1 as t) update foo set id=id+10 where n  in (
SELECT INST_NUM()  AS n
  FROM cte1 )
;
select * from foo order by 1,2,3;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
       FROM test1 AS t
),
cte2 as (
       SELECT t.*
       , INST_NUM()  AS n
       FROM cte1 as t
) update foo set id=id+10 where INST_NUM()<=3 ;
select * from foo order by 1,2,3;


insert into foo
with cte as
(
 select * from test1 where inst_num() between 1 and 2
) select id,id+5,inst_num() from cte;

select * from foo order by 1,2,3;

with cte as
(
 select * from test1 where inst_num() between 1 and 2
) delete from foo where id in (select id from cte) and inst_num()<=2;

select * from foo order by 1,2,3;

insert into foo
with cte as
(
 select * from test1 where inst_num() between 1 and 2
) select id,id+5,inst_num() from cte where inst_num()<=5;

with cte as
(
 select * from test1 where inst_num() between 1 and 2
) update foo set id=id-10 where id in (select id from cte) and inst_num()<=2;

select * from foo order by 1,2,3;

drop table if exists foo,test1;
