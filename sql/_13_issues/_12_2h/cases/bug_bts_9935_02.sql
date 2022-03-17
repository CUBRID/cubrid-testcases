--+ holdcas on;

--
drop table if exists t;

CREATE TABLE t (a int)
PARTITION BY RANGE (a)
(PARTITION p10 values less than (10),
 PARTITION p30 values less than (30),
 PARTITION p50 values less than (50),
 PARTITION p70 values less than (70),
 PARTITION p90 values less than (90));
insert into t values (30);
select * from t partition(p50) order by 1;

drop table if exists t;


--
drop table if exists TEST;
  CREATE TABLE TEST
       (
        ID INT NOT NULL AUTO_INCREMENT,
        SETG_DATE TIMESTAMP NOT NULL DEFAULT now(),
        PRIMARY KEY (ID,SETG_DATE)
       )
        PARTITION  BY RANGE (TO_TIMESTAMP(SETG_DATE))
        (
       PARTITION d0 VALUES LESS THAN (0),
        PARTITION JAN  VALUES LESS THAN ('2012-01-01'),
        PARTITION FEB VALUES LESS THAN ('2012-03-01'),
        PARTITION MARCH VALUES LESS THAN ('2012-04-01'),
        PARTITION APRIL VALUES LESS THAN ('2012-05-01'),
        PARTITION MAY VALUES LESS THAN ('2012-06-01'),
        PARTITION JUNE VALUES LESS THAN ('2012-07-01'),
        PARTITION JULY VALUES LESS THAN ('2012-08-01'),
        PARTITION AUG  VALUES LESS THAN ('2012-09-01'),
        PARTITION SEP VALUES LESS THAN ('2012-10-01'),
        PARTITION OCT VALUES LESS THAN ('2012-11-01'),
        PARTITION d7 VALUES LESS THAN MAXVALUE
           );

insert test (SETG_DATE) values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test (SETG_DATE) values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test (SETG_DATE) values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
insert test (SETG_DATE) values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test (SETG_DATE) values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));
insert test (SETG_DATE) values(TO_TIMESTAMP('13-aug-25', 'YY-Mon-DD'));

insert test partition(JAN) (SETG_DATE)  values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));

REPLACE test (SETG_DATE) values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test (SETG_DATE) values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test (SETG_DATE) values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test (SETG_DATE) values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test (SETG_DATE) values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));

REPLACE test partition(JAN) (SETG_DATE)  values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
REPLACE test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));


select * from  test partition(JAN) order by 1;
delete test partition(JAN) ;
select * from  test partition(JAN) order by 1;
select * from  test  order by 1;
select * from  test where SETG_DATE in (select SETG_DATE from  test partition(OCT))  order by 1;
delete test where SETG_DATE in (select SETG_DATE from  test partition(OCT)  order by 1);

insert test partition(JAN) (SETG_DATE)  values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));

delete test where SETG_DATE in (select SETG_DATE from  test partition(OCT) order by 1 union all select SETG_DATE as t from  test partition(OCT) order by 1);


insert test partition(JAN) (SETG_DATE)  values(TO_TIMESTAMP('11-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(OCT) (SETG_DATE)  values(TO_TIMESTAMP('12-Oct-25 13:10:31', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS'));
insert test partition(AUG) (SETG_DATE)  values(TO_TIMESTAMP('12-aug-25', 'YY-Mon-DD'));
delete test partition(AUG ) where SETG_DATE in (select SETG_DATE from  test partition(OCT) union all select SETG_DATE from  test partition(OCT) );
delete test partition(OCT) where SETG_DATE in (select SETG_DATE from  test partition(OCT) union all select SETG_DATE from  test partition(OCT) );


select TO_TIMESTAMP('08-Dec-25 13:10:30', 'YY-Mon-DD HH24:MI:SS');
select TO_TIMESTAMP('08-Dec-25'); 
select TO_TIMESTAMP('12-aug-25 13:10:30', 'YY-Mon-DD HH24:MI:SS') ;
select TO_TIMESTAMP('12-Oct-25 13:10:30', 'YY-Mon-DD HH24:MI:SS') ;

select * from test order by 1;
select * from test partition(OCT ) order by 1;

drop table if exists TEST;


--

drop table if exists T2;
CREATE TABLE t2 (
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    region_code INT NOT NULL,
    dob DATE NOT NULL
)
PARTITION BY RANGE( YEAR(dob) ) (
    PARTITION d0 VALUES LESS THAN (1970),
    PARTITION d1 VALUES LESS THAN (1975),
    PARTITION d2 VALUES LESS THAN (1980),
    PARTITION d3 VALUES LESS THAN (1985),
    PARTITION d4 VALUES LESS THAN (1990),
    PARTITION d5 VALUES LESS THAN (2000),
    PARTITION d6 VALUES LESS THAN (2005),
    PARTITION d7 VALUES LESS THAN MAXVALUE
);

insert t2 (fname,lname,region_code,dob) (values('oo3','xx3',3,date('1982-06-23')));
insert t2 (fname,lname,region_code,dob) values('oo3','xx3',3,date('1982-06-23'));
insert t2 (fname,lname,region_code,dob) values('oo4','xx4',4,date('1992-06-23'));
insert t2 (fname,lname,region_code,dob) values('oo5','xx5',6,date('1999-06-21'));

REPLACE t2 (fname,lname,region_code,dob) values('oo3','xx3',3,date('1982-06-23'));
REPLACE t2 (fname,lname,region_code,dob) values('oo4','xx4',4,date('1992-06-23'));
REPLACE t2 (fname,lname,region_code,dob) values('oo5','xx5',6,date('1999-06-21'));

insert t2 partition(d3) (fname,lname,region_code,dob) values('oo3','xx3',3,date('1982-06-23'));
insert t2 partition(d5) (fname,lname,region_code,dob) values('oo4','xx4',4,date('1992-06-23'));
insert t2 partition(d5) (fname,lname,region_code,dob) values('oo5','xx5',6,date('1999-06-21'));

REPLACE t2 partition(d3)  (fname,lname,region_code,dob) values('oo3','xx3',3,date('1982-06-23'));
REPLACE t2 partition(d5)  (fname,lname,region_code,dob) values('oo4','xx4',4,date('1992-06-23'));
REPLACE t2 partition(d5)  (fname,lname,region_code,dob) values('oo5','xx5',6,date('1999-06-21'));

SELECT * FROM t2 WHERE dob = '1982-06-23' order by 1;

SELECT * FROM t2 WHERE dob BETWEEN '1991-02-15' AND '1997-04-25' order by 1;

SELECT * FROM t2 WHERE dob >= '1984-06-21' AND dob <= '1999-06-21' order by 1;


SELECT * FROM t2 partition (d3) WHERE dob = '1982-06-23' order by 1;
SELECT * FROM t2 partition (d4) WHERE dob = '1982-06-23' order by 1;

SELECT * FROM t2 WHERE dob BETWEEN '1991-02-15' AND '1997-04-25' order by 1;
SELECT * FROM t2 partition (d4,d5) WHERE dob BETWEEN '1991-02-15' AND '1997-04-25' order by 1;

SELECT * FROM t2 WHERE dob >= '1984-06-21' AND dob <= '1999-06-21' order by 1;


insert t2 (fname,lname,region_code,dob) values('ab','cd',1,date('2010-10-04'));
insert t2 (fname,lname,region_code,dob) values('ab','cd',1,date('2012-10-04'));

drop table if exists T2;
--
drop table if exists T;
create table t (i int);
insert into t values(1);
select * from t order by 1;
insert into t values((1));
select * from t order by 1;
insert into t values((((((((((((1))))))))))));
select * from t order by 1;
drop table if exists T;






--
drop table if exists T2;
CREATE TABLE t2 (
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    region_code INT NOT NULL,
    dob DATE NOT NULL
)
PARTITION BY RANGE( YEAR(dob) ) (
    PARTITION d0 VALUES LESS THAN (1970),
    PARTITION d1 VALUES LESS THAN (1975),
    PARTITION d2 VALUES LESS THAN (1980),
    PARTITION d3 VALUES LESS THAN (1985),
    PARTITION d4 VALUES LESS THAN (1990),
    PARTITION d5 VALUES LESS THAN (2000),
    PARTITION d6 VALUES LESS THAN (2005),
    PARTITION d7 VALUES LESS THAN MAXVALUE
);
insert t2 (fname,lname,region_code,dob) values('oo3','xx3',3,date('1984-06-21'));
select * from t2 partition(d3) order by 1;
insert t2 (fname,lname,region_code,dob) values('oo3','xx3',3,date('1999-06-21'));
select * from t2 partition(d5) order by 1;
SELECT * FROM t2 WHERE dob = '1982-06-23';
SELECT * FROM t2 WHERE dob BETWEEN '1991-02-15' AND '1997-04-25';
SELECT * FROM t2 WHERE dob >= '1984-06-21' AND dob <= '1999-06-21';


drop table if exists T2;

--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS 4;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;

--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS 40000;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;
--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS -1;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;
--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS 100;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;
--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS 200;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;
--
drop table if exists T1;
CREATE TABLE t1 (a int unique)
partition by hash(a) PARTITIONS 102;
insert into t1 values (1),(2);
select * from t1 ORDER BY a DESC;
drop table if exists T1;

--
drop table if exists T1;
CREATE TABLE `t1` (
  `name` char(30) default NULL,
  `unixtime` int(20) default NULL,
  KEY `unixtime_idx` (`unixtime`),
  KEY `idx_name` (`name`)
) PARTITION BY RANGE ( unixtime) (PARTITION p1 VALUES LESS THAN (1136102400), PARTITION p2 VALUES LESS THAN (1167638400));

insert into t1 values('aab',112);
insert into t1 values('aab',1136102401);
select * from t1 order by 1;
alter table t1 drop partition p2;
select * from t1 order by 1;

drop table if exists T1;

--
drop table if exists T2;
CREATE TABLE `t2` ( 
`col1` int(11) DEFAULT NULL 
) 
PARTITION BY LIST ( col1) 
(partition p1 values in (null)); 

alter table t2 
add partition 
(partition p2 values in (1)); 

;sc t2

alter table t2 
add partition 
(partition p3 values in (2) );
;sc t2

drop table if exists T2;
drop table if exists t2;

--
drop table if exists T10;
create table t10 (a int) partition by hash(a) PARTITIONS 3;
ALTER TABLE t10 ADD PARTITION PARTITIONS 4;
drop table if exists T10;
--
drop table if exists T10;
create table t10 (a int) partition by hash(a) PARTITIONS 102;
ALTER TABLE t10 ADD PARTITION PARTITIONS 4;
drop table if exists T10;
--
drop table if exists T10;
create table t10 (a int) partition by hash(a) PARTITIONS 4;
ALTER TABLE t10 ADD PARTITION PARTITIONS 102;
ALTER TABLE t10 ADD PARTITION PARTITIONS 1;
drop table if exists T10;
--
drop table if exists T10;
create table t10 (a int) partition by hash(a) PARTITIONS 20;
;sc t10
ALTER TABLE t10 drop PARTITION p15;
;sc t10
drop table if exists T10;

--
drop table if exists T10;
create table t10 (a int) partition by range(a)    (
    PARTITION d0 VALUES LESS THAN (1970),
    PARTITION d1 VALUES LESS THAN (1975),
    PARTITION d2 VALUES LESS THAN (1976),
    PARTITION d3 VALUES LESS THAN MAXVALUE
);
;sc t10
insert into t10 values(1973);
insert into t10 values(1974);
insert into t10 values(1975);
insert into t10 values(1976);
select * from t10 order by 1;
ALTER TABLE t10 drop PARTITION d1;
select * from t10 order by 1;
;sc t10
select * from t10 order by 1;
ALTER TABLE t10 drop PARTITION d3;
select * from t10 order by 1;
drop table if exists T10;


--
drop table if exists employees,a,b;
CREATE TABLE employees (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT,
    store_id INT,unique(id,store_id)
)
PARTITION BY LIST(store_id) (
    PARTITION pNorth VALUES IN (3,5,6,9,17),
    PARTITION pEast VALUES IN (1,2,10,11,19,20),
    PARTITION pWest VALUES IN (4,12,13,14,18),
    PARTITION pCentral VALUES IN (7,8,15,16)
);
create table a as select * from employees;
create table b like employees;
;sc a
;sc b
;sc employees

drop table if exists employees,a,b;
--
drop table if exists employees,a,b;
CREATE TABLE employees (
    id INT NOT NULL unique,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT,
    store_id INT
);

drop table if exists employees,a,b;

create table a as select * from employees;
create table b like employees;
;sc a
;sc b
;sc employees

drop table if exists employees,a,b;


--
DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (f_int1 INTEGER) PARTITION BY RANGE(f_int1)
(PARTITION p1 VALUES LESS THAN (0), PARTITION p2 VALUES LESS THAN (10));
INSERT INTO t1 SET f_int1 = NULL ;
SELECT * FROM t1;
SELECT * FROM t1 WHERE f_int1 IS NULL;

DROP TABLE IF EXISTS t1;
--
DROP TABLE IF EXISTS `table`;
CREATE TABLE `table` (
  `id` int(11)  NOT NULL AUTO_INCREMENT,
  `lastcomment` int(10)  NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) 
PARTITION BY RANGE (id) 
(PARTITION p0 VALUES LESS THAN (88134) 
, PARTITION p1 VALUES LESS THAN (96695) , 
PARTITION p2 VALUES LESS THAN MAXVALUE );

ALTER TABLE `table` DROP PARTITION p1;
ALTER TABLE `table` ADD PARTITION (PARTITION p1 VALUES LESS THAN (179721));
ALTER TABLE `table` ADD PARTITION (PARTITION p1 VALUES LESS THAN (96694));
ALTER TABLE `table` ADD PARTITION (PARTITION p1 VALUES LESS THAN (2));

DROP TABLE IF EXISTS `table`;
--
DROP TABLE IF EXISTS `table`;
CREATE TABLE `table` (
  `id` int(11)  NOT NULL AUTO_INCREMENT,
  `lastcomment` int(10)  NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) 
PARTITION BY RANGE (id) 
(PARTITION p0 VALUES LESS THAN (88134) , 
PARTITION p1 VALUES LESS THAN (96695),
PARTITION p2 VALUES LESS THAN (100000)
) ;

ALTER TABLE `table` DROP PARTITION p1;
ALTER TABLE `table` ADD PARTITION (PARTITION p1 VALUES LESS THAN (179721));
ALTER TABLE `table` ADD PARTITION (PARTITION p1 VALUES LESS THAN (96694));
ALTER TABLE `table` ADD PARTITION (PARTITION p1VALUES LESS THAN (2));
DROP TABLE IF EXISTS `table`;

--+ holdcas off;
