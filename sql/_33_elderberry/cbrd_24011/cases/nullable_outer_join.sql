drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100));
insert into tab_a select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tab_b select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create index idx on tab_a(col_a,col_b);
create index idx on tab_b(col_a,col_b);

update statistics on all classes;
select /*+ recompile */ count(*)
  from tab_a a
        ,(select col_a, max(col_b) col_b from tab_b group by col_a) b
  where a.col_a = b.col_a (+)
    and b.col_b = 1
    and nvl(b.col_a,0) = 1;

create or replace view v_a as select col_a, max(col_b) col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
  from tab_a a
      ,v_a b
  where a.col_a = b.col_a (+)
    and b.col_b = 1
    and nvl(b.col_a,0) = 1;

update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a left join
      (select col_a, max(col_b) col_b from tab_b group by col_a) b on a.col_a = b.col_a 
where b.col_a = 2;

create or replace view v_a as select col_a, max(col_b) col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a left join v_a b on a.col_a = b.col_a
where b.col_a = 2;

update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a left join
      (select col_a, max(col_b) col_b from tab_b group by col_a) b on a.col_a = b.col_a
where nvl(b.col_a,1) = 2;

create or replace view v_a as select col_a, max(col_b) col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a left join v_a b on a.col_a = b.col_a 
where nvl(b.col_a,1) = 2;
update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a
      ,(select col_a, max(col_b) col_b from tab_b group by col_a) b
where a.col_a = b.col_a
  and nvl(b.col_a,0) = 1;

create or replace view v_a as select col_a, max(col_b) col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
from tab_a a
      ,v_a b
where a.col_a = b.col_a
  and nvl(b.col_a,0) = 1;
update statistics on all classes;
select /*+ recompile */ count(*)
from (select col_a, col_b from tab_b group by col_a) a
       inner join
       tab_a b on a.col_a = b.col_a
       right outer join
       tab_a c on b.col_a = c.col_a  
where nvl(a.col_a,0) = 1;

create or replace view v_a as select col_a, col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
from v_a a
       inner join
       tab_a b on a.col_a = b.col_a
       right outer join
       tab_a c on b.col_a = c.col_a 
where nvl(a.col_a,0) = 1;
update statistics on all classes;
select /*+ recompile */ count(*)
from (select col_a, col_b from tab_b group by col_a) a,
       tab_a b 
       right outer join
       tab_a c on b.col_a = c.col_a  
where a.col_a = c.col_a
  and nvl(a.col_a,0) = 1;

create or replace view v_a as select col_a, col_b from tab_b group by col_a;

update statistics on all classes;
select /*+ recompile */ count(*)
from v_a a,
       tab_a b 
       right outer join
       tab_a c on b.col_a = c.col_a  
where a.col_a = b.col_a
  and nvl(a.col_a,0) = 1;

drop view v_a;
drop table if exists tab_a, tab_b;

