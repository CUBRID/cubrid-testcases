drop table if exists tpr;
drop table if exists tpr__p__p_20;
drop table if exists v1;
drop table if exists v2;
drop table if exists v3;

create table tpr(i int)
partition by range (i)(
partition p_10 values less than (10),
partition p_20 values less than (20),
partition p_30 values less than (30),
partition p_100 values less than (100));

insert into tpr values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
insert into tpr select i + 10 from tpr;
insert into tpr select i + 20 from tpr;


create view v1 as select * from tpr;
select * from v1 order by 1;
alter table tpr promote partition p_20;
select * from v1 order by 1;
create view v2 as select * from tpr;
select * from v2 order by 1;
create view v3 as select * from tpr__p__p_20;
select * from v3 order by 1;

alter table tpr reorganize partition p_30 into(partition p_201 values less than (20),partition p_30 values less than (30));
insert /*+ insert_execution_mode(31)*/ into tpr values(17);
select * from v1 order by 1;
select * from v2 order by 1;

alter table tpr__p__p_20 partition by hash(i) partitions 10;
insert into tpr__p__p_20 values(100);
select * from v3 order by 1;

alter table tpr add column j int;
update tpr set j=0;
alter table tpr remove partitioning;
select * from v1 order by 1;
select * from v2 order by 1;

drop tpr;
drop tpr__p__p_20;
drop v1;
drop v2;
drop v3;
