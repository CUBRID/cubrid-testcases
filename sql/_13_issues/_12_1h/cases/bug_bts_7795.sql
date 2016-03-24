create table tbl(i int) partition by range(i) (partition p1 values less than(3),partition p2 values less than(6));
insert into tbl values(1),(2),(3),(4),(5);
alter table tbl reorganize partition p1,p2 into(partition p12 values less than(6));
alter table tbl reorganize partition p12 into (partition p11 values less than(2),partition p22 values less than(6));
select * from tbl order by 1;
drop tbl;

create table tbl(i int) partition by range(i) (partition p0 values less than(10),partition p1 values less than(20));
insert into tbl values(5),(15);
alter table tbl promote partition p0;
alter table tbl reorganize partition p1 into(partition p2 values less than(15),partition p3 values less than(20));
select * from tbl order by 1;
drop tbl;
drop tbl__p__p0;

create table tbl(d date) partition by hash(d) partitions 5;
insert into tbl select adddate('2012-2-2',rownum) from db_class limit 10;
create index i on tbl(d) where d>'2012-1-1';
alter table tbl coalesce partition 3;
alter table tbl add partition partitions 2;
select * from tbl order by 1;
alter table tbl remove partitioning;
alter table tbl partition by list(d) (
partition p0 values in ('2012-2-3','2012-2-4','2012-2-5','2012-2-6'),
partition p1 values in ('2012-2-7','2012-2-8'),
partition p2 values in('2012-2-9','2012-2-11','2012-2-10','2012-2-12'));
select * from tbl order by 1;
alter table tbl promote partition p2;
alter table tbl reorganize partition p1 into (
partition p1 values in ('2012-2-7','2012-2-8'),
partition p12 values in(NULL));
select * from tbl order by 1 desc;

drop tbl;
drop tbl__p__p2;
