--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20), c char(20), s string);
create index i_t1_v on t1(v);
create index i_t1_c on t1(c);
create index i_t1_s on t1(s);

insert into t1 values (1, 'dbms qa1 part', 'dbms qa1 part', 'dbms qa1 part');
insert into t1 values (2, 'dbms qa1 part', 'dbms qa1 part', 'dbms qa1 part');
insert into t1 values (3, 'dbms qa2 part', 'dbms qa2 part', 'dbms qa2 part');
insert into t1 values (4, 'dbms qa2 part', 'dbms qa2 part', 'dbms qa2 part');
insert into t1 values (5, null, null, null);
insert into t1 values (6, '', '', '');

select /*+ recompile */ * from t1 where v like 'dbms%';
select /*+ recompile */ * from t1 where v like 'dbms qa1%';
select /*+ recompile */ * from t1 where v like 'dbms qa1 part%';
select /*+ recompile */ * from t1 where v like 'dbms qa1 part';
select /*+ recompile */ * from t1 where v like 'dbms%' order by v desc, id desc;
select /*+ recompile */ * from t1 where v like '%part';
select /*+ recompile */ * from t1 where v like '%qa1 part';
select /*+ recompile */ * from t1 where v like '%dbms qa1 part';
select /*+ recompile */ * from t1 where v like '%1%';
select /*+ recompile */ * from t1 where v like '%';
select /*+ recompile */ * from t1 where v like '%%';

select /*+ recompile */ * from t1 where c like 'dbms%';
select /*+ recompile */ * from t1 where c like 'dbms qa1%';
select /*+ recompile */ * from t1 where c like 'dbms qa1 part%';
select /*+ recompile */ * from t1 where c like 'dbms qa1 part';
select /*+ recompile */ * from t1 where c like 'dbms%' order by c desc, id desc;
select /*+ recompile */ * from t1 where c like '%part';
select /*+ recompile */ * from t1 where c like '%qa1 part';
select /*+ recompile */ * from t1 where c like '%dbms qa1 part';
select /*+ recompile */ * from t1 where c like '%1%';
select /*+ recompile */ * from t1 where c like '%';
select /*+ recompile */ * from t1 where c like '%%';

select /*+ recompile */ * from t1 where s like 'dbms%';
select /*+ recompile */ * from t1 where s like 'dbms qa1%';
select /*+ recompile */ * from t1 where s like 'dbms qa1 part%';
select /*+ recompile */ * from t1 where s like 'dbms qa1 part';
select /*+ recompile */ * from t1 where s like 'dbms%' order by s desc, id desc;
select /*+ recompile */ * from t1 where s like '%part';
select /*+ recompile */ * from t1 where s like '%qa1 part';
select /*+ recompile */ * from t1 where s like '%dbms qa1 part';
select /*+ recompile */ * from t1 where s like '%1%';
select /*+ recompile */ * from t1 where s like '%';
select /*+ recompile */ * from t1 where s like '%%';


drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
