drop table if exists t;
create table t(a varchar(255));
show create table t;
drop table t;

create table t(a varchar(255)) collate utf8_en_cs;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) collate utf8_en_cs;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) collate utf8_en_cs partition by hash(a) partitions 3;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs partition by hash(a) partitions 3;
show create table t;
drop table t;

create table t(i int auto_increment, a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs, auto_increment = 10 partition by hash(a) partitions 3 as select rownum as [rownum], cast(rownum as varchar(255)) as [ cast(rownum as varchar(255))] from db_class;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) collate utf8_en_cs;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) collate utf8_en_cs partition by hash(a) partitions 3;
show create table t;
drop table t;

create table t(a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs partition by hash(a) partitions 3;
show create table t;
drop table t;

create table t(i int auto_increment, a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs, auto_increment = 10 partition by hash(a) partitions 3 as select rownum as [rownum], cast(rownum as varchar(255)) as [ cast(rownum as varchar(255))] from db_class;
show create table t;
drop table t;

create table t(i int auto_increment(1,2), a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs  partition by hash(a) partitions 3 as select rownum as [rownum], cast(rownum as varchar(255)) as [ cast(rownum as varchar(255))] from db_class;
show create table t;
drop table t;

create table t(i int auto_increment(1,2), a varchar(255) collate iso88591_bin) reuse_oid, collate utf8_en_cs  PARTITION BY LIST (i) (

PARTITION event1 VALUES IN (1, 2 ),

PARTITION event2 VALUES IN (3, 4,5),

PARTITION event3 VALUES IN (6, 7, 8)

);
show create table t;
drop table t;

CREATE TABLE t (host_year INT, nation CHAR(3) collate iso88591_bin, gold INT, silver INT, bronze INT)

PARTITION BY RANGE (host_year)

(PARTITION before_2000 VALUES LESS THAN (2000),

PARTITION before_2008 VALUES LESS THAN (2008) );

show create table t;
drop table t;










