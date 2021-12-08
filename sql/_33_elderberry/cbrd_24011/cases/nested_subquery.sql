drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100));
insert into tab_a select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tab_b select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create index idx on tab_a(col_a,col_b);
create index idx on tab_b(col_a,col_b);

select /*+ recompile */ count(*)
from tab_a a
      , (select col_a, cnt from (
          select col_a, cnt from (
            select col_a, cnt from (
                select col_a,count(*) cnt from tab_b group by col_a
        ) )
        ) ) d
where a.col_a = d.col_a
  and d.col_a = 1;

create or replace view v_a as select col_a, cnt from (
          select col_a, cnt from (
            select col_a, cnt from (
                select col_a,count(*) cnt from tab_b group by col_a
        ) )
        );

select /*+ recompile */ count(*)
from tab_a a
      ,v_a d
where a.col_a = d.col_a
  and d.col_a = 1;

drop view v_a;
drop table if exists tab_a, tab_b;

