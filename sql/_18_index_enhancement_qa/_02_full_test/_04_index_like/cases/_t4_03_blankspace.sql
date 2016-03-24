--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20), c char(20), s string);
create index i_t1_all on t1(v,c,s);
create index i_t1_v on t1(v);
create index i_t1_c on t1(c);
create index i_t1_s on t1(s);

insert into t1 values (1, 'dbms qa1 part', 'dbms qa1 part', 'dbms qa1 part');
insert into t1 values (3, 'dbms qa2 part', 'dbms qa2 part', 'dbms qa2 part');
insert into t1 values (4, 'aaa', 'aaa', 'aaa');
insert into t1 values (5, 'bbb', 'bbb', 'bbb');
insert into t1 values (6, 'ccc', 'ccc', 'ccc');
insert into t1 values (7, '', '', '');
insert into t1 values (8, ' ', ' ', ' ');
insert into t1 values (9, '  ', '  ', '  ');
insert into t1 values (10, ' x ', ' x ', ' x ');
insert into t1 values (11, null, null, null);

--TEST: bug
select /*+ recompile */ * from t1 where v like ' %'  order by 1;
select /*+ recompile */ * from t1 where c like ' %'  order by 1;
select /*+ recompile */ * from t1 where s like ' %'  order by 1;

--TEST: bug
select /*+ recompile */ * from t1 where v like '  %'  order by 1;

select /*+ recompile */ * from t1 where v like '% '  order by 1;
select /*+ recompile */ * from t1 where c like '% '  order by 1;
select /*+ recompile */ * from t1 where s like '% '  order by 1;

select /*+ recompile */ * from t1 where v like ' % '  order by 1;
select /*+ recompile */ * from t1 where c like ' % '  order by 1;
select /*+ recompile */ * from t1 where s like ' % '  order by 1;

select /*+ recompile */ * from t1 where v like '%'  order by 1;
select /*+ recompile */ * from t1 where c like '%'  order by 1;
select /*+ recompile */ * from t1 where s like '%' order by 1;

--TEST: another bug
select /*+ recompile */ * from t1 where v like '';
select /*+ recompile */ * from t1 where c like '';
select /*+ recompile */ * from t1 where s like '';

--TEST: another bug
select /*+ recompile */ * from t1 where v = '';
select /*+ recompile */ * from t1 where c = '';
select /*+ recompile */ * from t1 where s = '';

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
