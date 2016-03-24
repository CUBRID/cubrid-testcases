--CUBRIDSUS1190 reproduce sql

create table foo ( i int, j int, k int);
insert into foo values(1,1,1);
create table bar(i int primary key);
insert into bar values(1);

--set optimization level 513;
select * from bar, foo where bar.i in(foo.i, foo.j, foo.k) using index bar.pk_bar_i(+);
drop foo;
drop bar;

create table aaa(a integer);
insert into aaa values(1);
create index idx1 on aaa(a);

$INT, $1, $INT, $1, $INT, $1;
select rownum, a from aaa where a in(?,?,?) using index idx1(+);
drop aaa;