--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t (i1 int, i2 int, i3 varchar(10));
insert into t values (null, null, null);
insert into t values (0, 0, '00'), (0, 1, '01'), (0, 2, '02'), (0, 3, '03'), (0, 4, '04');
insert into t values (1, 0, '10'), (1, 1, '11'), (1, 2, '12'), (1, 3, '13'), (1, 4, '14');
create index i_ac on t (i1,i3);
create index i_all on t (i1,i2,i3);
insert into t values (2, 0, '20'), (2, 1, '21'), (2, 2, '22'), (2, 3, '23'), (2, 4, '24');
insert into t values (3, 0, '30'), (3, 1, '31'), (3, 2, '32'), (3, 3, '33'), (3, 4, '34');
insert into t values (4, 0, '40'), (4, 1, '41'), (4, 2, '42'), (4, 3, '43'), (4, 4, '44');

--TEST
select /*+ recompile */ * from t where i1 between 1 and 3 and i3 between '00' and '44' limit 6;

--TEST
select /*+ recompile */ * from t where i1 between 1 and 3 and i2 between 2 and 4 and i3 between '00' and '44' limit 6;

drop table t;set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
