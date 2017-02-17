drop table if exists t1;
create table t1 (id int, test_data varchar(36));

insert into t1(id, test_data)
select id, test_data
    from (
with recursive data_generator(id, test_data) as (
                select 1 as id, SYS_GUID() as test_data
                union all
                select id + 1, SYS_GUID() from data_generator where id < 1500
            )
        select * from data_generator 
	) as a;


drop table t1;

DROP TABLE IF EXISTS cbrd;
DROP view IF EXISTS cbrd2;
CREATE TABLE cbrd(
  a int(10)  NOT NULL,
  b int(10)  NOT NULL,
  PRIMARY KEY (a,b),
  KEY b(b)
);

INSERT INTO cbrd
  VALUES (1,3),(2,1),(2,4),(3,4),(3,5),(3,6),(4,7),(5,1),(5,6),(6,1);

DROP TABLE IF EXISTS cbrd2;
CREATE VIEW cbrd2 (a, b) AS 
 SELECT a, b FROM cbrd   UNION ALL   SELECT b, a FROM cbrd;

 WITH RECURSIVE transitive_closure(a, b, distance, path_string) AS
( SELECT a, b, 1 AS distance,
   concat(a, '.', b, '.') AS path_string
  FROM cbrd
 
  UNION ALL
 
  SELECT tc.a, e.b, tc.distance + 1,
  concat(tc.path_string, e.b, '.') AS path_string
  FROM cbrd AS e
    JOIN transitive_closure AS tc
      ON e.a = tc.b
  WHERE tc.path_string NOT LIKE concat('%', e.b, '.%')
)
SELECT * FROM transitive_closure
ORDER BY a, b, distance;

WITH RECURSIVE transitive_closure(a, b, distance, path_string) AS
( SELECT a, b, 1 AS distance,
         concat(a, '.', b, '.') AS path_string
  FROM cbrd
 WHERE a = 1 -- source
 
  UNION ALL
 
  SELECT tc.a, e.b, tc.distance + 1,
         concat(tc.path_string, e.b, '.') AS path_string
  FROM cbrd AS e
  JOIN transitive_closure AS tc ON e.a = tc.b
 WHERE tc.path_string NOT LIKE concat('%', e.b, '.%')
)
  SELECT * FROM transitive_closure
   WHERE b = 6 -- destination
ORDER BY a, b, distance;

WITH RECURSIVE transitive_closure(a, b, distance, path_string) AS
( SELECT  a, b, 1 AS distance,
          concat(a, '.', b, '.') AS path_string
  FROM cbrd2
 
  UNION ALL
 
  SELECT tc.a, e.b, tc.distance + 1,
  concat(tc.path_string, e.b, '.') AS path_string
  FROM cbrd2 AS e
    JOIN transitive_closure AS tc ON e.a = tc.b
  WHERE tc.path_string NOT LIKE concat('%', e.b, '.%')
)
SELECT * FROM transitive_closure
ORDER BY a, b, distance;

WITH RECURSIVE transitive_closure(a, b, distance, path_string)
AS
( SELECT a, b, 1 AS distance,
         concat(a, '.', b, '.') AS path_string
  FROM cbrd2
 
  UNION ALL
 
  SELECT tc.a, e.b, tc.distance + 1,
         concat(tc.path_string, e.b, '.') AS path_string
  FROM cbrd2 AS e
  JOIN transitive_closure AS tc ON e.a = tc.b
 WHERE tc.path_string NOT LIKE concat('%', e.b, '.%')
)
SELECT a, b, min(distance) AS dist FROM transitive_closure
GROUP BY a, b
ORDER BY a, dist, b;

DROP view cbrd2;
DROP TABLE cbrd;
