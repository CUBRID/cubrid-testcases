drop table if exists t;
create table t(id int,col char(10)) partition by range(id)(partition p1 values less than (501),partition p2 values less than (1001));
alter table t reorganize partition p1 into(partition p1 values less than (200),partition p1 values less than (501));
drop table t;
