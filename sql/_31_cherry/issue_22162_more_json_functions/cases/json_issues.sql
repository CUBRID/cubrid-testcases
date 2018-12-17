-- http://jira.cubrid.org/browse/CBRD-22510
SELECT * from JSON_TABLE('[{"x": 2, "y": 8 }]', '$[0]' COLUMNS (x int PATH '$.x', y int PATH '$.y')) as t1 limit 1;
SELECT * from JSON_TABLE('[{"x": 2, "y": 8 }]', '$[0]' COLUMNS (x int PATH '$.x', y int PATH '$.y')) as t1 limit 1;
SELECT * from JSON_TABLE('[{"x": 2, "y": 8 }]', '$[0]' COLUMNS (x int PATH '$.x', y int PATH '$.y')) as t1 limit 1;
SELECT * from JSON_TABLE('[{"x": 2, "y": 8 }]', '$[0]' COLUMNS (x int PATH '$.x', y int PATH '$.y')) as t1 limit 1;

-- http://jira.cubrid.org/browse/CBRD-22511
drop table if exists t1;
create table t1 (a varchar(20));
insert into t1 values ('hello');
select * from JSON_TABLE((select json_object('title', a) from t1), '$' COLUMNS (x VARCHAR(10) PATH '$.title')) as t;
delete from t1;
select * from JSON_TABLE((select json_object('title', a) from t1), '$' COLUMNS (x VARCHAR(10) PATH '$.title')) as t;
drop table if exists t1;

-- http://jira.cubrid.org/browse/CBRD-22525
select * from JSON_TABLE(
   (SELECT x from  JSON_TABLE('{"x": "2"}', '$' COLUMNS (x JSON PATH '$')) as t1), 
   '$' COLUMNS (x JSON PATH '$')) as t;

-- http://jira.cubrid.org/browse/CBRD-22528
select cast (1 as date) i_json,  jt.a from json_table('{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt;

-- http://jira.cubrid.org/browse/CBRD-22535
drop table if exists t;
create table t (i int, j int, s string);
insert into t values (1,9,'one');
insert into t values (2,8,'two');
insert into t values (3,7,'three');
insert into t values (4,6,'four');
insert into t values (5,5,'five');
insert into t values (6,4,'six');
insert into t values (7,3,'seven');
insert into t values (8,2,'eight');
insert into t values (9,1,'nine');
select * , j_tbl.col1, j_tbl.col2, json_array_append(j_tbl.col1, '$' ,j_tbl.col2 ) 
from json_table('{"a":[1,2]}', '$' columns(
   col1 varchar(10) path '$.a' , 
   nested path '$.a[*]' columns ( col2 int path '$' )
)) as j_tbl, (select * from t order by 1) 
where i > 0 and rownum >= 4 and rownum <= 8;
-- Execute above query again, cub_server will crash.
select * , j_tbl.col1, j_tbl.col2, json_array_append(j_tbl.col1, '$' ,j_tbl.col2 ) 
from json_table('{"a":[1,2]}', '$' columns(
   col1 varchar(10) path '$.a' , 
   nested path '$.a[*]' columns ( col2 int path '$' )
)) as j_tbl, (select * from t order by 1) 
where i > 0 and rownum >= 4 and rownum <= 8;
drop table if exists t;

-- http://jira.cubrid.org/browse/CBRD-22530
drop table if exists t;
create table t(i int, j int) partition by hash(i) partitions 4;
insert into t values(1,  1);
select incr(i), jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t;
select incr(i), jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t
select incr(i), jt.a from json_table( '{"a":[1,2]}', '$' columns( a varchar(10) path '$.a' )) as jt, t;
drop table if exists t;

drop table if exists t1, t2;
create table t1(i int, j int) partition by hash(i) partitions 4;
insert into t1 values(1,  1);
create table t2(i int, j int) partition by hash(i) partitions 4;
insert into t2 values(1,  1);
select incr(t1.i), incr(t2.i) from t1, t2;
select incr(t1.i), incr(t2.i) from t1, t2
select incr(t1.i), incr(t2.i) from t1, t2;
drop table if exists t1, t2;

-- http://jira.cubrid.org/browse/CBRD-22551
select JSON_OBJECTAGG(null, 'hello');

-- http://jira.cubrid.org/browse/CBRD-22552
drop table if exists t1;
CREATE TABLE t1 (a int); 
insert into t1 values (1), (1), (null);
select a, JSON_OBJECTAGG(a, 1), count(*) from t1 group by a;
drop table if exists t1;

-- http://jira.cubrid.org/browse/CBRD-22513
select jt.a, default(jt.a) from json_table('{"a":[1,2 ]}', '$' columns( a char(10) path '$.a')) as jt;
select jt.a, default(jt.a) from json_table('{"a":[1,2 ]}', '$' columns( a json path '$.a')) as jt;
select jt.a, default(jt.a) from json_table('{"a":[1,2 ]}', '$' columns( a json path '$.a'  default '"000"' on error)) as jt;
select jt.a, default(jt.a) from json_table('{"a":[1,2 ]}', '$' columns( a json path '$.a'  default '"000"' on error default '111' on empty)) as jt;

-- http://jira.cubrid.org/browse/CBRD-22506
drop table if exists t;
CREATE TABLE t(c VARCHAR(10), i INT);
INSERT INTO t VALUES ('key', 3);
INSERT INTO t VALUES ('key', 4);
INSERT INTO t VALUES ('key', 5);
SELECT c, i FROM t order by 1,2;
SELECT JSON_OBJECTAGG(c, i) FROM t;

DELETE FROM t;
INSERT INTO t VALUES ('key', 3);
INSERT INTO t VALUES ('key', 5);
INSERT INTO t VALUES ('key', 4);
SELECT c, i FROM t order by 1,2;
SELECT JSON_OBJECTAGG(c, i) FROM t;

SELECT JSON_OBJECTAGG(c, i) FROM (select * from t order by i ) as t;
SELECT JSON_OBJECTAGG(c, i) FROM (select * from t order by i desc) as t;
drop table if exists t;

-- http://jira.cubrid.org/browse/CBRD-22577
drop table if exists t1;
CREATE TABLE t1 (i int auto_increment, a BIGINT);
insert into t1(a) values (2147483649);
insert into t1(a) values (12345678901234);
insert into t1(a) values (2147483649.9);
insert into t1(a) values (-12345678901234.7);
select * from t1 order by 1;
select json_objectagg(a,a) from t1 order by 1;
select json_arrayagg(a) from t1 order by 1;
select i, json_object(a,a), json_array(a,a,a,a,a) from t1 order by 1;

-- http://jira.cubrid.org/browse/CBRD-22557
drop table if exists t1;
create table t1 (a numeric(38,0));
insert into t1 values (1), (2);
select a, typeof(a), JSON_OBJECTAGG('name', a), JSON_ArrayAgg(a) from t1 group by a order by 1;
select json_object(a,a),json_array(a,a) from t1 group by a order by 1;      
drop table if exists t1;

