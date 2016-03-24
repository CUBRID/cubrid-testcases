create table tbl(i int) partition by range(i) (partition p0 values less than(10),partition p1 values less than maxvalue);
insert into tbl select rownum from db_class limit 10;

create trigger tr 
before update on tbl__p__p0
execute reject;

create trigger tr 
before update on tbl
execute reject;

alter table tbl promote partition p0;
alter trigger tr status inactive;
alter table tbl promote partition p0;

select count(*) from db_trigger where name='tr';
update tbl__p__p0 set i=100;
update tbl set i=100;
alter trigger tr status active;
update tbl set i=100;
update tbl__p__p0 set i=1000;
drop tbl;
select count(*) from db_trigger where name='tr';
drop tbl__p__p0;
select count(*) from db_trigger where name='tr';
