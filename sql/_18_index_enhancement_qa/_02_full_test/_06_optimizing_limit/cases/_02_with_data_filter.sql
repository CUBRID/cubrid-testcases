--+ holdcas on;
create table t (i1 int, i2 int, i3 varchar(10));
insert into t values (null, null, null);
insert into t values (0, 0, '00'), (0, 1, '01'), (0, 2, '02'), (0, 3, '03'), (0, 4, '04');
insert into t values (1, 0, '10'), (1, 1, '11'), (1, 2, '12'), (1, 3, '13'), (1, 4, '14');
create index i_i1 on t (i1);
create index i_i2 on t (i2);
create index i_i3 on t (i3);
insert into t values (2, 0, '20'), (2, 1, '21'), (2, 2, '22'), (2, 3, '23'), (2, 4, '24');
insert into t values (3, 0, '30'), (3, 1, '31'), (3, 2, '32'), (3, 3, '33'), (3, 4, '34');
insert into t values (4, 0, '40'), (4, 1, '41'), (4, 2, '42'), (4, 3, '43'), (4, 4, '44');

set system parameters 'xasl_debug_dump=yes';

--TEST
select /*+ recompile */ * from t where i1 between 1 and 3 and i1%2=0 order by i1, i2, i3 limit 8;
--TEST
select /*+ recompile */ * from t where i1 between 1 and 2 and i3 like '%2%' order by i1, i2, i3  limit 8;
--TEST
select /*+ recompile */ * from t where i1 between 1 and 3 and i1>1  order by i1, i2, i3  limit 8;

--TEST
select /*+ recompile */ * from t where i1 <2 order by i1,i2 desc limit 3,8;

--TEST
select /*+ recompile */ * from t where (i1 is null or i1 is not null) and i1 between 1 and 8 order by i1,i2 desc limit 8;

--TEST
select /*+ recompile */ * from t where i2 between 1 and 3 and i2%2=0 limit 8;
--TEST
select /*+ recompile */ * from t where i2 between 1 and 2 and i3 like '%2%' limit 8;
--TEST
select /*+ recompile */ * from t where i2 between 1 and 3 and i2>1  limit 8;

--TEST
select /*+ recompile */ * from t where i2 <2 limit 3,8;

--TEST
select /*+ recompile */ * from t where (i2 is null or i2 is not null) and i2 between 1 and 8 limit 8;

--TEST
select /*+ recompile */ * from t where i1 between 1 and 3 and rownum%2=0 limit 8;

set system parameters 'xasl_debug_dump=no';

drop table t;
commit;
--+ holdcas off;
