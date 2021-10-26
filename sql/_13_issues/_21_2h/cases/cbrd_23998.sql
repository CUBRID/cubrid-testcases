drop table if exists tbl;
create table tbl (a int);
insert into tbl values(3);
alter table tbl add column b int;
insert into tbl values(4,4);
select /*+ select_record_info */ t_reprid from tbl;
drop table if exists tbl;

create table tbl (a char(20000));
insert into tbl values('abcde');
alter table tbl add column b char(20000);
insert into tbl values('abc','abc');
select /*+ select_record_info */ t_reprid from tbl;
drop table if exists tbl;
