drop table if exists pt_hash, pt_range, pt_list, t1, t2, t3, tt, tt1;
create table pt_hash (i int, j int) partition by hash(i) partitions 5;

create table pt_range (k int, l int) partition by range(k) (partition less_100 values less than(100), partition less_500 values less than(500));

create table pt_list (m char, n char) partition by list(n) (partition p1 values in('a', 'b'),partition p2 values in('c', 'd'));

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

WITH cte_Sn10sxmqS AS(select * from tt1 order by 1,2)select * from cte_Sn10sxmqS;

alter table tt1 drop superclass tt;

WITH cte_0ImBeCsoT AS(select * from tt1 order by 1,2)select * from cte_0ImBeCsoT;

WITH RECURSIVE t(a) AS (
                SELECT name FROM db_user
                UNION ALL
                SELECT  a FROM  t WHERE 1 = 0
        )SELECT * FROM  t;

drop table if exists p_disc;
create table p_disc(
col1 int,
col2 short,
col3 bigint,
col4 numeric(10, 5),
col5 float,
col6 double,
col7 monetary
)
partition by range(col1)
(partition p1 values less than (20000),
partition p2 values less than (30000),
partition p3 values less than (40000),
partition p4 values less than (50000),
partition p5 values less than (60000)
);

insert into p_disc values(10000, 100, 10000000, 12345.06789, 111.11, 11111.130, 1000);

insert into p_disc values(10000, 200, 20000000, 12345.06789, 111.12, 11111.129, 1000);

insert into p_disc values(10000, 100, 30000000, 12345.16789, 111.13, 11111.128, 1000);

insert into p_disc values(10000, 200, 40000000, 12345.06789, 111.14, 11111.127, 1000);

insert into p_disc values(10000, 100, 50000000, 12345.16789, 111.15, 11111.126, 1000);

insert into p_disc values(20000, 200, 70000000, 12345.06789, 111.16, 11111.125, 1000);

insert into p_disc values(20000, 100, 80000000, 12345.06789, 111.17, 11111.124, 1000);

insert into p_disc values(20000, 100, 10000000, 12345.26789, 111.18, 11111.123, 1000);

insert into p_disc values(20000, 300, 20000000, 12345.06789, 111.19, 11111.122, 1000);

insert into p_disc values(30000, 100, 30000000, 12345.06789, 111.20, 11111.121, 1000);

insert into p_disc values(30000, 100, 40000000, 12345.16789, 111.21, 11111.120, 1000);

insert into p_disc values(30000, 300, 50000000, 12345.06789, 111.23, 11111.119, 1000);

insert into p_disc values(40000, 100, 10000000, 12345.06789, 111.24, 11111.118, 1000);

insert into p_disc values(50000, 100, 20000000, 12345.06789, 111.25, 11111.117, 1000);

insert into p_disc values(50000, 200, 30000000, 12345.06789, 111.26, 11111.116, 1000);
insert into p_disc values(50000, 100, 40000000, 12345.56789, 111.27, 11111.115, 1000);

insert into p_disc values(50000, 100, 50000000, 12345.06789, 111.28, 11111.114, 1000);

insert into p_disc values(50000, 300, 60000000, 12345.56789, 111.29, 11111.113, 1000);

insert into p_disc values(50000, 100, 70000000, 12345.06789, 111.30, 11111.112, 1000);

insert into p_disc values(50000, 100, 80000000, 12345.56789, 111.31, 11111.111, 1000);

WITH cte_1KYROy AS
(
select col1, col2, col3, col4, col5, col6, col7, percentile_disc(0.88) within group (order by col1) over() p_disc from p_disc where trunc(col6)=111 order by 1, 2, 3, 4, 5, 6, 7
)
select * from cte_1KYROy;

WITH cte_8iNz3G AS
(
select *, percentile_disc(0.999) within group (order by col2) over() p_disc from p_disc) order by 1, 2, 3, 4, 5, 6, 7
)
select * from cte_8iNz3G;

WITH cte_8iNz3G(a,b,c,d,e,f,g,h) AS
(
select *, percentile_disc(0.999) within group (order by col2) over() p_disc from p_disc) order by 1, 2, 3, 4, 5, 6, 7
)
select * from cte_8iNz3G;


WITH cte_vJfJzG AS
(
select col1, col3, col5, percentile_disc(0) within group (order by col2) over p_disc from p_disc
)
select * from cte_vJfJzG order by 1,2,3,4;

WITH cte_vJfJzG(col1,col2,col3,col4) AS
(
select col1, col3, col5, percentile_disc(0) within group (order by col2) over p_disc from p_disc
)
select * from cte_vJfJzG order by 1,2,3,4;

drop table if exists pt_hash; 
drop table if exists pt_range; 
drop table if exists pt_list;
drop table if exists t1;
drop table if exists t2; 
drop table if exists t3; 
drop table if exists tt; 
drop table if exists tt1;
drop table if exists p_disc;

