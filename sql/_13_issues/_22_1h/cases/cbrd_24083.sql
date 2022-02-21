DROP TABLE IF EXISTS t1;
-- case1
/* same: DOUBLE, NUMERIC */
CREATE TABLE t1 (c1 INT);
INSERT INTO t1 VALUES (1);
INSERT INTO t1 VALUES (0);
INSERT INTO t1 VALUES (-1);
INSERT INTO t1 VALUES (NULL);

SELECT * FROM t1;
UPDATE t1 SET c1 = 9 WHERE c1;
SELECT * FROM t1;

DROP TABLE t1;

-- case2
CREATE TABLE t1 (c1 varchar);
INSERT INTO t1 VALUES ('A');
INSERT INTO t1 VALUES ('');
INSERT INTO t1 VALUES (NULL);

SELECT * FROM t1;

UPDATE t1 SET c1 = 'Z' WHERE c1;
SELECT * FROM t1;
DROP TABLE t1;

-- case3
CREATE TABLE t1 (c1 DATETIME);
INSERT INTO t1 VALUES (SYSDATETIME);
INSERT INTO t1 VALUES (NULL);

UPDATE t1 SET c1 = TO_DATETIME('1970-01-01') WHERE c1;
DROP TABLE t1;

-- case4
create table t1 (dummy varchar);
insert into t1 values ('X');
select 1, true, (true and false), (true or false), null, unknown from t1;
select (true is true), (true is not false), (true is false), (true is not true) from t1;
select (null is null), (unknown is null) from t1;
select (null is unknown), (unknown is unknown) from t1;
select (null=1), ((null=1)is unknown), ((null=1)is null) from t1;
select (1 = null), (null = null), (unknown = unknown), (unknown = null), (null = unknown) from t1;
select (false xor true) from t1;
select (false xor (1=1)) from t1;
select (1 and 1) from t1;
select (1 and true) from t1;
select (false or 1) from t1;
select (1 xor 0) from t1;
select (false xor 1) from t1;
select if(true, 'T', 'F') from t1;
select if(true and true, 'T', 'F') from t1;
select if(1<3, 'T', 'F') from t1;
select if((1<3) = true, 'T', 'F') from t1;
select if((1<3) = 1, 'T', 'F') from t1;
select if((1<3) is true, 'T', 'F') from t1;
select if((1<3) is not true, 'T', 'F') from t1;
select if(1, 'T', 'F') from t1; 
select if( 1 <> 0, 'T', 'F') from t1;
select if( 1 = 1, 'T', 'F') from t1;
select if(least(3,1,7), 'T', 'F') from t1; 
select if(least(3,1,7) > 2, 'T', 'F') from t1;
select ((select true from t1) is true) from t1;
select ((select true from t1) = true) from t1;
select ((select true from t1) = 1) from t1
select ((select null from t1) is null) from t1;
select ((select null from t1) = null) from t1;
select if((select 2 from t1), 'T', 'F') from t1; 
select if((select 2 from t1) > 0, 'T', 'F') from t1;
select 1 from t1 where true;
select 1 from t1 where 1;
select 1 from t1 where dummy;
select 1 from t1 where dummy is null or 1;
select 1 from t1 where (1 > 0) and dummy;
select 1 from t1 where 1 or true;
select 1 from t1 where false or true;
select 1 from t1 where (false or true);
select 1 from t1 where not false;
select 1 from t1 where not dummy;
select 1 from t1 where dummy is true;
select 1, true, (true and false), (true or false), null, unknown from t1;
select (true is true), (true is not false), (true is false), (true is not true) from t1;
select (null is null), (unknown is null) from t1;
select (null is unknown), (unknown is unknown) from t1; 
select (null=1), ((null=1)is unknown), ((null=1)is null) from t1;
select ( null = null ), (unknown = unknown ), (unknown = null), (null = unknown) from t1;
select (1 and 1) from t1;
select (1 and true) from t1;
select (false or 1) from t1;
select (1 xor 0) from t1;
select (false xor 1) from t1; 
select (false xor true) from t1;
select (false xor (1=1)) from t1;
select (1 is true);
select (1 is false);
select (0 is true);
select (0 is false);
select (2 is true);
select (2 is false);

select (1 = true);
select (true = 1);
select (1 = false);
select (false = 1);

select (0 = true);
select (true = 0);
select (0 = false);
select (false = 0);

select (2 = true);
select (true = 2);
select (2 = false);
select (false = 2);

select (1 = null), (0 = null), (null = 1), (null = 0);
select (1 is null), (0 is null);

select (null = null);
select (unknown = unknown);

select (unknown = null);
select (null = unknown);

select (null is null);
select (unknown is null);

select (null is unknown);
select (unknown is unknown); 
drop table t1;
