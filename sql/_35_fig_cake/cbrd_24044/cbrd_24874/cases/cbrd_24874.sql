-- This scenario varifies CBRD-24874 issue.
-- Minimize rule based optimization and delete heuristic factor.


drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100),col_c varchar(100),col_d varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100),col_c varchar(100),col_d varchar(100));
insert into tab_a select to_char(rownum) col_a, '1' col_b, to_char(rownum) col_c,'1' col_d from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9})  e,table({0,1,2,3,4,5,6,7,8,9})  f limit 100000;
insert into tab_b select to_char(rownum) col_a, to_char(rownum) col_b, '1' col_c,'1' col_d from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9})  e,table({0,1,2,3,4,5,6,7,8,9})  f limit 200000;

create index idx on tab_a(col_a,col_b);
create index idx2 on tab_a(col_c);
create index idx on tab_b(col_a,col_b);
create index idx2 on tab_b(col_c);
create index idx3 on tab_b(col_c,col_d);

update statistics on tab_a, tab_b;

--Delete RBO
--RBO is used only when cost is within 1.x difference.
--join order should be b->a refer to selectivity has been calculated correctly in index's second column.
select /*+ recompile */ * from tab_b b, tab_a a
where a.col_a = b.col_a
and a.col_b = '1'
and b.col_b = '1';

-- Only 7 pages are collected when sampling statistics.
-- b.col_c NDV has been calculated correctly, so join order should be a->b.
select /*+ recompile */ count(*) from tab_a a, tab_b b
where a.col_a = b.col_a
and b.col_c = '1';

-- Order by skip is not always prefer than any other scan.
select /*+ recompile */ col_b from tab_b a
where a.col_a = '1'
and a.col_c >= '1'
order by col_c;

--Indexes matching many columns are selected regardless of selectivity.
select /*+ recompile */ count(*)
from tab_b b
where col_c = '1'
and col_d = '1'
and col_a = '1';

--Generate seq_scan even if index scan can be generated. In RBO, prefer index scan compared to sequence scan.
select /*+ recompile index_ss */ count(*)
from tab_b b
where col_b = '1';


drop table tab_a, tab_b;
