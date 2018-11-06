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
     , row_number() OVER (ORDER BY id2) AS n
  FROM cte1 AS t
;

replace into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t;

select * from foo;

replace into foo
WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 as t) select * from cte2
;
select * from foo;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 as t) delete from foo where n in (
SELECT row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 )
;
select * from foo;

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     ),
cte2 as (
SELECT t.*
     , row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 as t) update foo set id=id+10 where n not in (
SELECT row_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 )
;
select * from foo;

