drop table if exists main1,child1,child2;
create table main1(i int);
create table child1 under main1(j int, ch varchar(10));
alter table child1 partition by range(i) (partition p0 values less than (500), partition p1 values less than (600));
create table child2 under main1(j int, ch varchar(10)) partition by range(i) (partition p0 values less than (500), partition p1 values less than (600));
drop child1;

create table child1 under main1(j int, ch varchar(10));
alter table child1 partition by hash(i) partitions 4;
create table child2 under main1(j int, ch varchar(10)) partition by hash(i) partitions 5;
drop child1,main1;
