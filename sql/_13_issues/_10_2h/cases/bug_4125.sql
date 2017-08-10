--+ holdcas on;
--1. Create the following table and indexes.
set  system parameters 'dont_reuse_heap_file=yes';
create table x (a int primary key, b int, c int, d int);

insert into x select rownum, rownum/100+1, rownum/100+1, rownum%100 from db_class c1,db_class c2, db_class c3  limit 20000;

create index i_abc on x (a, b, c);
create index i_abcd on x (a, b, c, d);
update statistics on all classes with fullscan;
-- 2. When the same range term is given, the plan which has more key filters should be taken.

-- index i_abc should be selected
select /*+ recompile */ * from x where a = 1 and c = 1;

-- index i_abcd should be selected
select /*+ recompile */ * from x where a = 1 and c = 1  and d = 1;

-- 3.  If the number of key filters are same, the smaller one should be taken. Before testing the following query, many records should be inserted first to increase the size of indexes. It might be 10,000 records or more. You can get the query statements by the following script.

create index i_acd on x (a, c, d);

update statistics on x with fullscan;
select /*+ recompile */ * from x where a = 1 and d = 1;

drop table x;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
