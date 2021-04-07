--+ holdcas on;

create table a(i int, s varchar(255));
create table b(i int, s varchar(255));
create table c(i int, s varchar(255));

insert into a select rownum, rownum from _db_class limit 40;
insert into b select rownum, rownum from _db_class limit 40;
insert into c select rownum, rownum from _db_class limit 40;

update statistics on all classes;

select /*+ recompile */ b.s, a.i
from a
	left join b on a.s = b.s
	left join c on b.s = c.s
order by a.i desc, a.i + b.i, b.s desc
limit 10;

select /*+ recompile */ b.s, a.i
from a, b, c
WHERE a.s = b.s AND b.s = c.s
order by a.i desc, a.i + b.i, b.s desc
limit 10;

drop table a;
drop table b;
drop table c;

create table a(i int, f float, dbl double, t time, d date, dt datetime, s varchar(255));
create table b(i int, f float, dbl double, t time, d date, dt datetime, s varchar(255));
create table c(i int, f float, dbl double, t time, d date, dt datetime, s varchar(255));

insert into a select rownum, rownum, rownum, time'00:00:00' + rownum, date'2010-01-01' + rownum, datetime'2010-01-01 00:00:00' + rownum, rownum from _db_class limit 40;
insert into b select rownum, rownum, rownum, time'00:00:00' + rownum, date'2010-01-01' + rownum, datetime'2010-01-01 00:00:00' + rownum, rownum from _db_class limit 40;
insert into c select rownum, rownum, rownum, time'00:00:00' + rownum, date'2010-01-01' + rownum, datetime'2010-01-01 00:00:00' + rownum, rownum from _db_class limit 40;

update statistics on all classes;

select /*+ recompile */ b.s, a.i
from a
	left join b on a.s = b.s
	left join c on b.s = c.s
order by a.dt desc, a.i + b.t, b.s desc
limit 5;

select /*+ recompile */ b.s, a.i
from a
	left join b on a.s = b.s
	left join c on b.s = c.s
order by a.i + b.t desc, a.dt desc, b.s desc
limit 5;

select /*+ recompile */ b.s, a.i
from a
	left join b on a.s = b.s
	left join c on b.s = c.s
order by a.i + b.t, a.dt desc, b.s desc
limit 5;

drop table a;
drop table b;
drop table c;

--+ holdcas off;
