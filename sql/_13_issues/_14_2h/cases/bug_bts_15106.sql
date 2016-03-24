drop table if exists members;
CREATE TABLE members (
    id INT,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob DATE
)
PARTITION BY RANGE( YEAR(dob) ) (
    PARTITION p0 VALUES LESS THAN (1970),
    PARTITION p1 VALUES LESS THAN (1980),
    PARTITION p2 VALUES LESS THAN (1990)
);
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (2000));

drop table if exists members;
CREATE TABLE members (
    id INT,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob DATE
)
PARTITION BY RANGE( month(dob) ) (
    PARTITION p0 VALUES LESS THAN (2),
    PARTITION p1 VALUES LESS THAN (6),
    PARTITION p2 VALUES LESS THAN (8)
);
insert into members values(1,'steve','jobs','1953-02-24');
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (20));
insert into members values(1,'steve','jobs','2011-10-04');
select * from members partition(p1);
select * from members partition(p3);

drop table if exists members;
CREATE TABLE members (
    id INT,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob DATE
)
PARTITION BY RANGE( to_days(dob) ) (
    PARTITION p0 VALUES LESS THAN (15),
    PARTITION p1 VALUES LESS THAN (21)
);
insert into members values(1,'steve','jobs','1953-02-24');
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (713374));
insert into members values(1,'steve','jobs','1953-02-24');
select * from members;
select * from members partition(p3);
drop table if exists members;
CREATE TABLE members (
    id INT,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob time
)
PARTITION BY RANGE( month(dob) ) (
    PARTITION p0 VALUES LESS THAN (4),
    PARTITION p1 VALUES LESS THAN (8),
    PARTITION p2 VALUES LESS THAN (10)
);
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (13));
ALTER TABLE members ADD PARTITION (PARTITION p4 VALUES LESS THAN (26));
drop members;

drop table if exists t;
create table t(dob time) partition by range(time(dob))
(partition p0 values less than ('12:12:12'));
alter table t add partition (partition p1 values less than ('24:24:24'));
 insert into t values(time '23:24:24');

 drop table if exists t;
create table t(dob time) partition by list(time(dob))
(partition p0 values in ('12:12:12'));
alter table t add partition (partition p1 values in ('24:24:24'));
 insert into t values(time '12:12:12');
 select * from t;

  drop table if exists t;
create table t(dob datetime) partition by range(time(dob))
(partition p0 values less than ('12:12:12'));
alter table t add partition (partition p1 values less than ('24:24:24'));
 insert into t values( '2001-12-12 12:12:12.399');
 select * from t;

 drop table if exists t;
create table t(dob timestamp) partition by range(time(dob))
(partition p0 values less than ('12:12:12'));
alter table t add partition (partition p1 values less than ('24:24:24'));
 insert into t values( '2001-12-12 12:12:12.399');
 select * from t;

  drop table if exists t;
create table t(dob timestamp) partition by list(time(dob))
(partition p0 values in ('12:12:12'));
alter table t add partition (partition p1 values in ('24:24:24'));
 insert into t values( '2012-12-12 12:12:12');
 select * from t;

drop table if exists t;
create table t(dob time) partition by range(time_to_sec(dob))
(partition p0 values less than (82800));
alter table t add partition (partition p1 values less than (82899));
 insert into t values( '23:01:24');
 insert into t values( '11:11:11');
select * from t order by 1;


drop table if exists t;
create table t(dob time) partition by range(timediff(dob,'12:12:12'))
(partition p0 values less than ('1:1:1'));
alter table t add partition (partition p1 values less than ('2:2:2'));
 insert into t values( '11:11:11');
 insert into t values( '13:13:13');
select * from t;
drop table if exists t;
create table t(dob date) partition by range(datediff(dob,'2010-03-02'))
(partition p0 values less than (0));
alter table t add partition (partition p1 values less than (5));
 insert into t values( '2010-2-28 23:59:59');
 insert into t values( '2010-03-03');
select * ,datediff(dob,'2010-03-02') from t;
drop table if exists t;
create table t(dob datetime) partition by range(datediff(dob,'2010-03-02'))
(partition p0 values less than (0));
alter table t add partition (partition p1 values less than (5));
 insert into t values( '2010-2-28 23:59:59');
 insert into t values( '2010-03-03');
select * ,datediff(dob,'2010-03-02') from t;
drop table if exists t;
create table t(dob timestamp) partition by range(datediff(dob,'2010-03-02'))
(partition p0 values less than (0));
alter table t add partition (partition p1 values less than (5));
 insert into t values( '2010-2-28 23:59:59');
 insert into t values( '2010-03-03');
select *,datediff(dob,'2010-03-02') from t;
drop t;

drop table if exists foo;
create table foo(i int) partition by list (sec_to_time(i))
(partition p0 values in ('11:00:00 pm'));
insert into foo values(82800);
alter table foo add partition (partition p1 values in ('11:00:01 pm'));
insert into foo values(82801);
insert into foo values('11:00:01 pm');
select * from foo order by 1;

drop table if exists foo;
create table foo(i int) partition by list (sec_to_time(i))
(partition p0 values in (86399));
insert into foo values(86399);
alter table foo add partition (partition p1 values in (86398));
insert into foo values(86398);
insert into foo values('11:00:01 pm');
select * from foo order by 1;
show create table foo;

 drop table if exists foo;
 create table foo(a date,b timestamp,c datetime) partition by range(quarter(a))
 (partition p0 values less than (3));
 insert into foo(a) values('2010-05-05');
 alter table foo add partition (partition p1 values less than (5));
 insert into foo(a) values('2010-11-05');
 select * from foo order by 1;
 drop table if exists foo;
 create table foo(a date,b timestamp,c datetime) partition by range(quarter(b))
 (partition p0 values less than (3));
 insert into foo(b) values('2010-05-05 12:34:56');
 alter table foo add partition (partition p1 values less than (5));
 insert into foo(b) values('2010-11-05 12:34:56')
 select * from foo order by 1;
 drop table if exists foo;
 create table foo(a date,b timestamp,c datetime) partition by range(quarter(c))
 (partition p0 values less than (3));
 insert into foo(c) values('2010-05-05 12:34:56.999');
 alter table foo add partition (partition p1 values less than (5));
 insert into foo(c) values('2010-11-05 12:34:56.999');
 select * from foo order by 1;
 drop foo;

 drop table if exists x;
 create table x(a date,b time,c timestamp,d datetime) partition by list(dayofmonth(a))
(partition p0 values in (12));
insert into x(a) values('2012-12-12');
alter table x add partition (partition p1 values in(31));
insert into x(a) values('2012-12-31');
select * from x order by 1;
drop table if exists x;
 create table x(a date,c timestamp,d datetime) partition by list(dayofmonth(c))
(partition p0 values in (12));
insert into x(c) values('2012-12-12 12:12:12');
alter table x add partition (partition p1 values in(31));
insert into x(c) values('2012-12-31 12:12:12');
select * from x order by 1;
drop table if exists x;
 create table x(a date,c timestamp,d datetime) partition by list(dayofmonth(d))
(partition p0 values in (12));
insert into x(d) values('2012-12-12 12:12:12.990');
alter table x add partition (partition p1 values in(31));
insert into x(d) values('2012-12-31 12:12:12.990');
select * from x order by 1;
drop x;
