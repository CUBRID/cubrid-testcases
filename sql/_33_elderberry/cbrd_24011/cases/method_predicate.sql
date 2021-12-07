drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100));
insert into tab_a select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tab_b select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create index idx on tab_a(col_a,col_b);
create index idx on tab_b(col_a,col_b);

create function test() return int
as language java
name 'SpTest.testInt10() return int';

select /*+ recompile */ count(*)
from tab_a a
      ,(select col_a, col_b from tab_b b group by col_a ) b
where a.col_a = b.col_b
  and b.col_a = test();

create or replace view v_a as select col_a, col_b from tab_b b group by col_a;

select /*+ recompile */ count(*)
from tab_a a
      ,v_a b
where a.col_a = b.col_a
  and b.col_a = test();

drop function test;
drop view v_a;
drop index idx on tab_a;
drop index idx on tab_b;
drop table if exists tab_a, tab_b;

