drop table if exists tt1;
drop table if exists tt;
create table tt1;
create table tt (c1 varchar(50), c2 int);
insert into tt (
select cast(rownum as varchar(50)), rownum from _db_class a, _db_class b, _db_class c
union
select cast(rownum || '  ' as varchar(50)), rownum from _db_class a, _db_class b
);
create index idx_tt on tt(c1);
create index idx_tt_d on tt(c1 desc);
drop table if exists tt1;
drop table if exists tt;

