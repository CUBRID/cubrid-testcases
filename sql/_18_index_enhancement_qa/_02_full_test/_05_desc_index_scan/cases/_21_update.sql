create table t (a int, b varchar(10), c char(10), d timestamp);

create index i_t_a_b_c_d  on t(a,b,c,d);

insert into t select rownum, rownum||'', rownum||'', sys_timestamp from db_class a, db_class b, db_class c limit 10000;

update t set b = a%100 order by a desc;

drop table t;


