--+ holdcas on;
create table t (id int primary key, a varchar(10));
insert into t values (1,'11');
insert into t values (2,'22');
insert into t values (3,'33');
insert into t values (4,null);
insert into t values (5,'2');
insert into t values (6,'23');

create reverse index i_t_a on t(a);

set system parameters 'xasl_debug_dump=yes';

select /*+ recompile */ a from t where a>'2' order by a asc;

select /*+ recompile */ a from t where a>'2' order by a asc for orderby_num() between 2 and 3;

select /*+ recompile */ a from t where a>'2' order by a asc for orderby_num() <=2;


select /*+ recompile */ a from t where a>'2' order by a desc;

select /*+ recompile */ a from t where a>'2' order by a desc for orderby_num() between 2 and 3;

select /*+ recompile */ a from t where a>'2' order by a desc for orderby_num() <=2;

select /*+ recompile use_desc_idx */ a from t where a>'2' limit 2;

select /*+ recompile use_desc_idx */ a from t where a>'2' limit 0,2;

select /*+ recompile use_desc_idx */ a from t where a>'2' and rownum<2;

set system parameters 'xasl_debug_dump=no';

drop table t;




commit;
--+ holdcas off;
