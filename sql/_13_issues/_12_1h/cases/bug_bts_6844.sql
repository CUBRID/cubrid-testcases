create table tbl(i int,j int);
create unique index idx on tbl(i) where j=0;
insert into tbl values(2,0),(2,1);
update tbl set j = 0 where i=2;
delete from tbl;
drop tbl;
