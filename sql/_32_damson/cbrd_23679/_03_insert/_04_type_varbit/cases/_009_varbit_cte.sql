set system parameters 'allow_truncated_string=no';
---------- INSERT INTO ...
---------- WITH cte AS (SELECT ...)
---------- SELECT * FROM cte ORDERBY 1;

drop table if exists t2;
drop table if exists t1;

create table t2 (parent_id int, code bit varying(20));
insert into t2 values (1, b'11');
insert into t2 values (1, b'1111');
insert into t2 values (2, b'101010');
insert into t2 values (2, b'10101010');
insert into t2 values (3, b'1010111110101111');
insert into t2 values (3, b'1111111111111111');
insert into t2 values (4, b'1110111011101110');

-- precision > value : OK
drop table if exists t1;
create table t1 (col1 bit varying(20));
show columns from t1;
insert into t1 with 
a AS (SELECT code FROM t2 WHERE parent_id = 1),
b AS (SELECT code FROM t2 WHERE parent_id = 2),
c AS (SELECT code FROM t2 WHERE parent_id = 3)
SELECT * FROM a 
UNION ALL SELECT * FROM b
UNION ALL SELECT * FROM c ORDER BY 1;
select * from t1 order by 1;

-- precision = value : OK
drop table if exists t1;
create table t1 (col1 bit varying(16));
show columns from t1;
insert into t1 with 
c AS (SELECT code FROM t2 WHERE parent_id = 3),
d AS (SELECT code FROM t2 WHERE parent_id = 4)
SELECT * FROM c 
UNION ALL SELECT * FROM d ORDER BY 1;
select * from t1 order by 1;

-- precision < value :data overflow
drop table if exists t1;
create table t1 (col1 bit varying(4));
show columns from t1;
insert into t1 with 
b AS (SELECT code FROM t2 WHERE parent_id = 2),
c AS (SELECT code FROM t2 WHERE parent_id = 3),
d AS (SELECT code FROM t2 WHERE parent_id = 4)
SELECT * FROM b 
UNION ALL SELECT * FROM c 
UNION ALL SELECT * FROM d ORDER BY 1;
select * from t1 order by 1;

drop table t1;
drop table t2;

set system parameters 'allow_truncated_string=no';
