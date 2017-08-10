--scenario1:test data type
drop table if exists t;
create table t(i int) partition by range(i) (partition p0 values less than (11),partition p1 values less than(5),partition p2 values less than(9));
alter table t add partition (partition p3 values less than (8));
alter table t add partition (partition p3 values less than (12));

drop table if exists t;
create table t(i varchar(20)) partition by range(i) (partition p0 values less than ('11'),partition p1 values less than('5'),partition p2 values less than('70'));
alter table t add partition (partition p3 values less than ('8'));
alter table t add partition (partition p4 values less than ('12'));

drop table if exists t;
create table t(i date) partition by range(i) (partition p0 values less than ('2014-12-25'),partition p1 values less than('2014-12-16'),partition p2 values less than('2015-1-1'));
alter table t add partition (partition p3 values less than ('2014-10-1'));
alter table t add partition (partition p3 values less than ('2015-5-24'));

drop table if exists t;
create table t(i date) partition by range(i) (partition p0 values less than ('2014-12-25'),partition p1 values less than('2014-12-26'),partition p2 values less than('2015-1-1'));
alter table t add partition (partition p3 values less than ('2014-10-1'));
alter table t add partition (partition p3 values less than ('2015-5-24'));

drop table if exists t;
create table t(i timestamp) partition by range(i) (partition p0 values less than ('2014-12-25 12:12:12'),partition p1 values less than('2014-12-16 12:12:12'),partition p2 values less than('2015-1-1 12:12:12'));
alter table t add partition (partition p3 values less than ('2014-10-1'));
alter table t add partition (partition p3 values less than ('2015-5-24'));

drop table if exists t;
create table t(i timestamp) partition by range(i) (partition p0 values less than ('2014-12-25 12:12:12'),partition p1 values less than('2014-12-26 12:12:12'),partition p2 values less than('2015-1-1 12:12:12'));
alter table t add partition (partition p3 values less than ('2014-10-1 12:12:12'));
alter table t add partition (partition p3 values less than ('2015-5-24 12:12:12'));

--scenario2:test function

drop table if exists t;
create table t(i int) partition by range(to_char(i)) (partition p0 values less than ('11'),partition p1 values less than('5'),partition p2 values less than('70'));
alter table t add partition (partition p3 values less than ('8'));
alter table t add partition (partition p4 values less than ('12'));

drop table if exists employees;
CREATE TABLE employees (
    id INT NOT NULL,
    fname VARCHAR(30),
    lname VARCHAR(30),
    hired DATE NOT NULL DEFAULT '1970-01-01',
    separated DATE NOT NULL DEFAULT '9999-12-31',
    job_code INT,
    store_id INT
)
PARTITION BY RANGE ( YEAR(separated) ) (
    PARTITION p0 VALUES LESS THAN (1996),
    PARTITION p1 VALUES LESS THAN (1991),
    PARTITION p2 VALUES LESS THAN (2001),
    PARTITION p3 VALUES LESS THAN MAXVALUE
);
drop table if exists employees;

--scenario3: partition reorganize
drop table if exists t;
create table t(i int) partition by range(i)(partition p1 values less than(10),partition p2 values less than(100));
insert into t values(1);
insert into t values(25);
insert into t  values(99);
alter table t reorganize partition p1 into (partition p1n1 values less than(10),partition p1n2 values less than(5));

drop table if exists t;
create table t(i int) partition by range(i)(partition p1 values less than(10),partition p2 values less than(100));
insert into t values(1);
insert into t values(25);
insert into t  values(99);
alter table t reorganize partition p1 into (partition p1n1 values less than(10),partition p1n2 values less than(15));

drop table if exists t;
create table t(i int) partition by range(i)(partition p1 values less than(10),partition p2 values less than(100));
insert into t values(1);
insert into t values(25);
insert into t  values(99);
alter table t reorganize partition p1 into (partition p1n1 values less than(5),partition p1n2 values less than(10));

--scenario4:list partition 
drop table if exists t;
create table t (i bigint) partition by list(i)(partition p1 values in (10,9,8,7),partition p2 values in (6,12,4,3));
alter table t add partition (partition p3 values in (15,1,18,17));
alter table t reorganize partition p1 into (partition p1n1 values in (10,8),partition p1n2 values in (7));

drop table if exists t;
create table t (i bigint) partition by list(i)(partition p1 values in (10,9,8,7),partition p2 values in (6,12,4,3));
alter table t add partition (partition p3 values in (15,1,18,17));
alter table t reorganize partition p1 into (partition p1n1 values in (10,8),partition p1n2 values in (7,9,100));
insert into t values(100);

drop table if exists t;
create table t (i bigint) partition by list(i)(partition p1 values in (10,9,8,7),partition p2 values in (6,12,4,3));
alter table t add partition (partition p3 values in (15,1,18,17));
alter table t reorganize partition p1 into (partition p1n1 values in (10,8),partition p1n2 values in (7,9,12));
insert into t values(12);

drop table if exists t;
create table t (i bigint) partition by list(i)(partition p1 values in (10,9,8,7),partition p2 values in (6,12,4,3));
alter table t add partition (partition p3 values in (15,1,18,17));
alter table t reorganize partition p1 into (partition p1n1 values in (10,8),partition p1n2 values in (7,9));

--scenario5:hash partition
drop table if exists t;
create table t(i date) partition by hash(i) partitions 5;
insert into t values('2014-12-12');
insert into t values('2013-12-12');
insert into t values('2012-12-12');
insert into t values('2011-12-12');
insert into t values('2010-11-11');
insert into t values('2009-10-1');
alter table t coalesce partition 2;
drop t;

