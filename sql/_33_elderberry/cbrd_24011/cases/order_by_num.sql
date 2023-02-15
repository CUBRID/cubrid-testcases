drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100));
insert into tab_a select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tab_b select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create index idx on tab_a(col_a,col_b);
create index idx on tab_b(col_a,col_b);

update statistics on tab_a;
update statistics on tab_b;

select /*+ recompile */ count(*)
from tab_a a
      ,(select col_a, col_b from tab_b order by col_a limit 1) b
where a.col_a = b.col_a
  and b.col_a = 2;
create or replace view v_a as select col_a, col_b from tab_b order by col_a limit 1;
select /*+ recompile */ count(*)
from tab_a a
      ,v_a b
where a.col_a = b.col_b
  and b.col_a = 2;
select /*+ recompile */ count(*)
from tab_a a
      ,(select col_a, col_b from tab_b group by col_a limit 3) b
where a.col_a = b.col_a
  and b.col_a = 2;
create or replace view v_a as select col_a, col_b from tab_b group by col_a limit 3;
select /*+ recompile */ count(*)
from tab_a a
      ,v_a b
where a.col_a = b.col_a
  and b.col_a = 2;

drop view v_a;
drop table if exists tab_a, tab_b;

