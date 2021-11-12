drop table if exists tab_a, tab_b;
create table tab_a (col1 varchar(100), col2 varchar(100));
create table tab_b (col1 varchar(100), col2 varchar(100));
insert into tab_a select to_char(rownum mod 100) col1, to_char(rownum) col2 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9})  e,table({0,1,2,3,4,5,6,7,8,9})  f limit 1000;
insert into tab_b select to_char(rownum mod 100) col1, to_char(rownum) col2 from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9})  e,table({0,1,2,3,4,5,6,7,8,9})  f limit 1000;

set optimization level 513;

select /*+ recompile */ count(*)
  from tab_a a
	,(select col1, max(col2) col2 from tab_b group by col1) b
  where a.col1 = b.col1 (+)
  and b.col2 = 1
  and nvl(b.col1,0) = 1;

drop table if exists tab_a, tab_b;

