--Partition promotion errors
--1. hash partitions cannot be promoted
create table t (i int, j int, k int)
partition by hash(i) partitions 10;

alter table t promote partition p5;

drop table t;

--2. promote from a normal class returns error
create table t(i int, j int, k int);
alter table t promote partition p5;
drop table t;

--3. promotion not allowed if referenced by foreign key
create table t (i int primary key, j int, k int) partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200)
);


create table u (i int, j int, k int, CONSTRAINT fk_i FOREIGN KEY(i) REFERENCES t(i));

alter table t promote partition p400;

drop table u;

drop table t;

--4. promote unexisting partition
create table t (i int primary key, j int, k int) partition by range (i) 
(
	partition p400 values less than (400),
	partition p800 values less than (800),
	partition p1200 values less than (1200)
);

alter table t promote partition p255;

drop table t;
