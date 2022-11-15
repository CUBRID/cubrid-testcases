drop table if exists tab_a, tab_b;
create table tab_a (col_a varchar(100), col_b varchar(100));
create table tab_b (col_a varchar(100), col_b varchar(100));
insert into tab_a select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
insert into tab_b select to_char(rownum mod 100) col_a, to_char(rownum) col_b from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b,table({0,1,2,3,4,5,6,7,8,9}) c,table({0,1,2,3,4,5,6,7,8,9}) d,table({0,1,2,3,4,5,6,7,8,9}) e,table({0,1,2,3,4,5,6,7,8,9}) f limit 1000;
create index idx on tab_a(col_a,col_b);
create index idx on tab_b(col_a,col_b);

--@queryplan
update statistics on all classes;
merge /*+ recompile */ into tab_a tt using (select col_a, count(*) col_b from tab_b group by col_a) st
  on (st.col_a=tt.col_a and st.col_b=tt.col_b and st.col_a = 10)
when matched then update set tt.col_a= st.col_a;

create or replace view v_a as select col_a, count(*) col_b from tab_b group by col_a;

--@queryplan
update statistics on all classes;
merge /*+ recompile */ into tab_a tt using v_a st
  on (st.col_a=tt.col_a and st.col_b=tt.col_b and st.col_a = 10)
when matched then update set tt.col_a= st.col_a;

drop view v_a;
drop table if exists tab_a, tab_b;

