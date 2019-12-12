create table t (a int primary key, b varchar(10), c char(10), d timestamp);

create reverse index ri_t_a_b_c_d on t(a,b,c,d);

insert into t select rownum, rownum||'', rownum||'', sys_timestamp from db_class a, db_class b, db_class c limit 1000;

insert /*+ recompile */ into t select * from t where b>'' order by a asc ON DUPLICATE KEY UPDATE b='0';

insert /*+ recompile */ into t select * from t where b>'' order by a asc ON DUPLICATE KEY UPDATE a=a, b=b,c=c,d=d;

replace /*+ recompile */ t select * from t where b>'' order by a asc;

replace /*+ recompile */ t select a*2,b,c,d from t where b>'' order by a asc;

select count(*),max(a),min(a) from t;

drop table t;

