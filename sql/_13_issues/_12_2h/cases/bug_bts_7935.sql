autocommit off;
drop table if exists tbl;
drop table if exists tbl__p__p0;
drop table if exists tbl__p__p11;

create table tbl(i int) partition by range(i) (partition p0 values less than(100), partition p1 values less than maxvalue);
insert into tbl select rownum from db_class limit 40;
alter table tbl promote partition p0;
alter table tbl reorganize partition p1 into (partition p11 values less than (150), partition p12 values less than maxvalue);
insert into tbl select rownum from db_class limit 40;
insert into tbl select rownum+40 from db_class limit 40;
insert into tbl select rownum+80 from db_class limit 40;
insert into tbl select rownum+160 from db_class limit 40;
insert into tbl select rownum+320 from db_class limit 40;
alter table tbl promote partition p11;
alter table tbl reorganize partition p12  into (partition p121 values less than (200), partition p122 values less than (300),partition p123 values less than maxvalue);
select count(*) from tbl__p__p121;
select count(*) from tbl__p__p122;
select count(*) from tbl__p__p123;
drop table if exists tbl;
drop table if exists tbl__p__p0;
drop table if exists tbl__p__p11;

create table tbl(i int) partition by range(i) (partition p0 values less than(100),partition p1 values less than (1000),partition p2 values less than maxvalue);
insert into tbl select rownum from db_class limit 40;
insert into tbl select rownum+40 from db_class limit 40;
insert into tbl select rownum+80 from db_class limit 40;

commit;

alter table tbl promote partition p1;
alter table tbl reorganize partition p2,p0 into (partition p3 values less than maxvalue);
select count(*) from tbl__p__p3;
select count(*) from tbl;
drop table if exists tbl;
drop table if exists tbl__p__p1;
rollback;

alter table tbl promote partition p2;
alter table tbl reorganize partition p1 into (partition p4 values less than (200),partition p5 values less than (1000));
select count(*) from tbl__p__p4;
drop table if exists tbl;
drop table if exists tbl__p__p2;
commit;
show tables;
commit;

autocommit on;

