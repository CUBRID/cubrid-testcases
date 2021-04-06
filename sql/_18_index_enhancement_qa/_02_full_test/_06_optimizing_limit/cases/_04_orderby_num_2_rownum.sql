--+ holdcas on;
create table t (i1 int, i2 int, i3 varchar(10));
insert into t values (null, null, null);
insert into t values (0, 0, '00'), (0, 1, '01'), (0, 2, '02'), (0, 3, '03'), (0, 4, '04');
insert into t values (1, 0, '10'), (1, 1, '11'), (1, 2, '12'), (1, 3, '13'), (1, 4, '14');
create index i_i1 on t (i1);
insert into t values (2, 0, '20'), (2, 1, '21'), (2, 2, '22'), (2, 3, '23'), (2, 4, '24');
insert into t values (3, 0, '30'), (3, 1, '31'), (3, 2, '32'), (3, 3, '33'), (3, 4, '34');
insert into t values (4, 0, '40'), (4, 1, '41'), (4, 2, '42'), (4, 3, '43'), (4, 4, '44');

--TEST
select * from (select /*+ recompile */ * from t where i1 > 0 order by i1 asc for orderby_num()> 5) t order by 1,2,3;
--TEST
select * from (select /*+ recompile */ * from t where i1 > 0 order by i1 asc for orderby_num() between 3 and 10) t order by 1,2,3;
--TEST
select * from (select /*+ recompile */ * from t where i1 > 0 order by i1 desc for orderby_num() >5) t order by 1,2,3;
--TEST
select * from (select /*+ recompile */ * from t where i1 > 0 order by i1, i2, i3 desc for orderby_num() between 3 and 10) t order by 1,2,3;

drop table t;
commit;
--+ holdcas off;
