create table tbl (
a int not null unique,
b int default 0,
c int);

insert into tbl values (0, 0, 0), (1, 1, 1);

select * from tbl;

-- expression
create table t1 (a int, b int, c int) as select (a*0) as [(a*0)], b, c from tbl;
create table t2 (a int, b int, c int) as select a, (b*0) as [(b*0)], c from tbl;
create table t3 (a int, b int, c int) as select a, b, (c*0) as [(c*0)] from tbl;

create table t4 (a int, b int, c int) as select a+b as [a+b], b+c as [b+c], c+a as [c+a] from tbl;
create table t5 (a int, b int, c int) as select a+b+c as [a+b+c], a*b*c as [a*b*c], a-b-c as [a-b-c] from tbl;

-- constant as name
create table t6 (a int, b int, c int) as select 1 as [1], 2 as [2], 3 as [3] from tbl;

-- alias
create table t7 (a int, b int, c int) as select tbl.c as a, tbl.a as b, tbl.b as c from tbl;
create table t8 (a int, b int, c int) as select tbl.a+tbl.b as a, tbl.b+tbl.c as b, tbl.c+tbl.a as c from tbl;



select * from t1;
select * from t2;
select * from t3;
select * from t4;
select * from t5;
select * from t6;
select * from t7;
select * from t8;


drop tbl;
drop t1;
drop t2;
drop t3;
drop t4;
drop t5;
drop t6;
drop t7;
drop t8;
