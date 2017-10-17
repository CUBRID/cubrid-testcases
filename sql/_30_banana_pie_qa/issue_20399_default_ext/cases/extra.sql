DROP CLASS IF EXISTS t1;
CREATE CLASS t1 (
	col1  int,
	col2 char(8) DEFAULT to_char(sysdate, 'YYYYMMDD')
);
DROP CLASS IF EXISTS t1;
CREATE CLASS t1 (
	col1  int,
	col2 char(8) DEFAULT to_char(sysdatetime, 'XYYYMMDD')
);

DROP TABLE IF EXISTS test01;
create table test01 (
col1 int,
col2 float DEFAULT 3.215,
col3 varchar(14),
col4 varchar(14),
PRIMARY KEY(col1));
alter table test01 alter column col4 set default to_char(sysdatetime, 'YYYYMMDDHH24MISS');
INSERT INTO test01 (col1, col3) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
SELECT IF(col3 = col4, 'OK', 'NOK') FROM test01;
DROP TABLE IF EXISTS test01;

create table test01 (
col1 int,
col2 float DEFAULT 3.215,
col3 varchar(14),
PRIMARY KEY(col1));
alter table test01 add column col4 varchar(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS');
INSERT INTO test01 (col1, col3) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
SELECT IF(col3 = col4, 'OK', 'NOK') FROM test01;
DROP TABLE TEST01;

DROP TABLE IF EXISTS test01;
create table test01 (
col1 int,
col2 float DEFAULT 3.215,
col3 char(14) DEFAULT to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int DEFAULT 0,
col5 varchar(14),
PRIMARY KEY(col1));
INSERT INTO test01 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
DROP TABLE IF EXISTS test03;
CREATE TABLE test03 AS SELECT * FROM test01;
SELECT COUNT(*) FROM TEST03;
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test03;
TRUNCATE TABLE TEST03;
INSERT INTO test03 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test03;
DROP TABLE TEST01;
DROP TABLE TEST03;

DROP CLASS IF EXISTS test01;
create table test01 (
col1 int,
col2 float default 3.215,
col3 char(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int default 0,
col5 varchar(14),
primary key(col1));
DROP CLASS IF EXISTS test02;
create table test02 like test01;

INSERT INTO test02 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

SELECT IF(col3 = col5, 'OK', 'NOK') FROM test02;

DROP TABLE TEST01;
DROP TABLE TEST02;
DROP CLASS IF EXISTS test01;
create table test01 (
col1 int,
col2 float default 3.215,
col3 char(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int default 0,
col5 varchar(14),
primary key(col1));
--
DROP CLASS IF EXISTS test02;
-- create using LIKE and 
-- 'test01' have extended default
create table test02 like test01;

-- INSERT DATA
INSERT INTO test02 (col1, col5) VALUES(1, TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

-- COMPARE RESULT
SELECT IF(col3 = col5, 'OK', 'NOK') FROM test02;

DROP TABLE TEST01;
DROP TABLE TEST02;
DROP CLASS IF EXISTS t02;
--
create table T02 (
col1 int PRIMARY KEY AUTO_INCREMENT,
col2 float default 3.215,
col3 char(14) default to_char(sysdatetime, 'YYYYMMDDHH24MISS'),
col4 int default 0,
col5 varchar(14))
partition by hash(col1) partitions 8;

-- INSERT DATA
INSERT INTO T02 (col5) VALUES(TO_CHAR(SYSDATETIME, 'YYYYMMDDHH24MISS'));

-- COMPARE RESULT
SELECT IF(col3 = col5, 'OK', 'NOK') FROM T02;

DROP TABLE T02;

DROP CLASS IF EXISTS test01;
CREATE TABLE test01 (
	col1 INT PRIMARY KEY AUTO_INCREMENT,
	col2 VARCHAR(19) DEFAULT TO_CHAR(SYSDATETIME, 'YYYYMMDD-HH24MISS-FF'),
	col3 VARCHAR(19)
);

INSERT INTO test01 (col3) VALUES(TO_CHAR(SYSDATETIME, 'YYYYMMDD-HH24MISS-FF'));
SELECT IF(col2 = col3, 'OK', 'NOK') FROM test01;

DROP TABLE test01;

DROP CLASS IF EXISTS t1;
CREATE CLASS t1 (
	col1  int,
	col2 char(8) DEFAULT to_char(sysdatetime, 'YYYYMMDD')
);
SELECT default_value FROM db_attribute
WHERE class_name = 't1' and attr_name = 'col2';
DROP CLASS IF EXISTS t1;
