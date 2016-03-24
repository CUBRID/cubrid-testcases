drop table if exists t1;
drop table if exists t2;
drop table if exists t3;

create table t1(i int) partition by range(i) (partition p0 values less than (100),partition p1 values less than(2147483650));
create table t1(i int) partition by range( i ) (partition p1 values less than(2147483650));
create table t1(i int) partition by range( i ) (partition p1 values less than(-2147483648),partition p2 values less than maxvalue);
drop t1;
create table t1(i int) partition by range( i ) (partition p1 values less than(-2147483649),partition p2 values less than (100));

create table t2(i int) partition by list(i) (partition p1 values in (-1,0),partition p2 values in (2147483648,2147483600));
create table t2(i int) partition by list(i) (partition p1 values in (-2147483649),partition p2 values in (0,2147483600));
create table t2(i int) partition by list(i) (partition p1 values in (-1,0),partition p2 values in (2147483647,2147483600));
drop t2;
create table t2(i int) partition by list(i) (partition p1 values in (-2147483648),partition p2 values in (0,2147483600));
drop t2;

create table t3(i smallint) partition by range(i) (partition p0 values less than (100),partition p1 values less than(32769));
create table t3(i bigint) partition by range(i) (partition p0 values less than (-9223372036854775809),partition p1 values less than(32769));


