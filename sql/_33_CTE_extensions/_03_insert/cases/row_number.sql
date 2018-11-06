drop table if exists test1;
CREATE TABLE test1 (
    id    int  auto_increment primary key
);

INSERT INTO test1  VALUES (null), (null), (null), (null);

WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , ROW_NUMBER() OVER (ORDER BY id2) AS n
  FROM cte1 AS t
;


WITH cte1 AS (
       SELECT t.*
            , t.id + 5 AS id2
         FROM test1 AS t
     )
SELECT t.*
     , ROW_NUMBER() OVER (PARTITION BY id2) AS n
  FROM cte1 AS t
