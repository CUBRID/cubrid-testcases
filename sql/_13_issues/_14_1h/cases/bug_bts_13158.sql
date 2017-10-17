autocommit off;
create table s1 (a int);
insert into s1 select rownum a from db_class x1, db_class x2, db_class x3, db_class x4 limit 100000;

create table t1(a int, b int, c int, d int);
insert into t1 (a,b,c,d) select mod(a,10), mod(a,1000), a, a from s1;
insert into t1 values (null, null, null, null);

create index idx_t1_abc on t1(a,b,c);
update statistics on t1 with fullscan;

set trace on;

select /*+ INDEX_LS */ a, min(b) from t1 where a>0 group by a;

show trace;

drop table t1;
drop table s1;
autocommit on;
