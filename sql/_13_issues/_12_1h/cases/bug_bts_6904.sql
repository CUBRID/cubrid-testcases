create table tbl(v varchar(10));
insert into tbl values(' c'),('cd'),('cdd');
create index idx on tbl(v) where v>'cd';
select * from tbl where v>='cd' using index idx;

drop tbl;
create table tbl(v varchar(10));
insert into tbl values(' c'),('cd'),('cdd');
create index idx on tbl(v) where v>'cc';
select * from tbl where v>='cd' using index idx;

drop tbl;