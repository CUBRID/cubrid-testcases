-- partition table can not be inherited.
drop table if exists pt_hash, pt_range, pt_list, t1, t2, t3, tt, tt1;

create table pt_hash (i int, j int) partition by hash(i) partitions 5;
create table pt_range (k int, l int) partition by range(k) ( 
       partition less_100 values less than(100),
       partition less_500 values less than(500)
);

create table pt_list (m char, n char) partition by list(n) (
       partition p1 values in('a', 'b'),
       partition p2 values in('c', 'd')
);

insert into pt_hash values(1, 1),(2, 2), (3, 3), (4, 4), (5, 5);
insert into pt_range values(10, 1),(20, 2), (300, 3), (400, 4), (50, 5);
insert into pt_list values(1, 'a'),(2, 'b'), (3, 'c'), (4, 'd'), (5, 'a');

-- create a table inheriting a partition table
create table t1 under pt_hash;
create table t2 under pt_range;
create table t3 under pt_list;

--alter a table by adding a super class
alter table pt_list add superclass pt_range;

create table tt(x int, y int);
create table tt1;
alter table tt1 add superclass pt_hash;
alter table tt1 add superclass pt_range, pt_list;
alter table tt1 add superclass tt, pt_range, pt_list;

-- this should work with non-partitioned table inheritance
alter table tt1 add superclass tt;
insert into tt1 values(1, 1), (2,2);
select * from tt1 order by 1,2;

alter table tt1 drop superclass tt;
select * from tt1 order by 1,2;

drop table if exists t, t2;
create table t (i char(10 ) PRIMARY KEY, j int) partition by hash(i) partitions 5;
insert into t values (1, 1);
create table t2 under t;
drop table if exists t, t2;
drop table if exists pt_hash, pt_range, pt_list, t1, t2, t3, tt, tt1;
