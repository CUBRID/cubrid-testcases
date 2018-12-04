drop table if exists tbl;
create table tbl(d date) partition by hash(d) partitions 5;

insert into tbl select adddate('2012-2-2',rownum) from db_class limit 10;

create index i on tbl(d) where d>'2012-1-1' with online;

alter table tbl coalesce partition 3;


drop table if exists tbl;
create table tbl(d date) partition by hash(d) partitions 5;

insert into tbl select adddate('2012-2-2',rownum) from db_class limit 10;

create index i on tbl(d) where d>'2012-1-1' with online;

alter table tbl add partition partitions 3;


drop table if exists tbl;
create table tbl(d date) partition by list(d) 
( 
partition p1 values in ('2011-10-1','2011-10-2','2011-10-3'),
partition p2 values in ('2011-10-4','2011-10-5','2011-10-6')

);
insert into tbl select adddate('2011-9-30',rownum) from db_class limit 6;
create index i on tbl(d) where d>'2011-10-1' with online;
alter table tbl coalesce partition 3;
alter table tbl drop partition p2;

drop table if exists tbl;
create table tbl(d date) partition by range(d) 
( 
partition p1 values less than ('2011-10-5'),
partition p2 values less than ('2012-10-1')

);
insert into tbl select adddate('2011-9-30',rownum) from db_class limit 6;
create index i on tbl(d) where d>'2011-10-1' with online;
alter table tbl coalesce partition 2;
alter table tbl drop partition p2;

drop table if exists tbl;
create table tbl(d date) partition by range(d)
(
partition p1 values less than ('2011-10-5'),
partition p2 values less than ('2012-10-1')

);
insert into tbl select adddate('2011-9-30',rownum) from db_class limit 6;
create index i on tbl(d) where d>'2011-10-1' with online;
alter table tbl add partition (
    PARTITION p3 VALUES LESS THAN ('2018-10-1'),
    PARTITION p4 VALUES LESS THAN MAXVALUE
);
insert into tbl select adddate('2018-9-30',rownum) from db_class limit 10;
drop table if exists tbl;







