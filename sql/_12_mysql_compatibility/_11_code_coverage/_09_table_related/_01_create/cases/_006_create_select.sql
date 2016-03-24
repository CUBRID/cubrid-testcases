create table tbl (a int not null unique, b int default 0, c int);

insert into tbl values (0, 0, 0), (1, 1, 1);

select * from tbl order by a,b,c;

create table tbl2 (a int, b int, c int shared) as select (a*0), b, c from tbl;

create table tbl2 (a int, b int, c int) as select (a*0), b, c from tbl;

select * from tbl2  order by 1,2,3;

create table tbl3 as select a as a_1, b, a + 1 as a from tbl;

select * from tbl3  order by 1,2,3;

insert into tbl3 values (NULL, 0, 0);

drop table tbl;
drop table tbl2;
drop table tbl3;
