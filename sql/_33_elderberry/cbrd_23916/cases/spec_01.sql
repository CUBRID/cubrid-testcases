create table tbl (a int);
insert into tbl values(3);
truncate tbl;
select count(*) from tbl;
truncate tbl cascade;
select count(*) from tbl;
drop tbl;

create table tbl (a int primary key);
insert into tbl values(3);
truncate tbl;
select count(*) from tbl;
truncate tbl cascade;
select count(*) from tbl;
drop tbl;

create table tbl (a int primary key);
alter table tbl add column b int references tbl(a);
insert into tbl values(3,3);
truncate tbl;
select count(*) from tbl;
truncate tbl cascade;
select count(*) from tbl;
drop tbl;
