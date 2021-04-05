--+ holdcas on;
create table t (a int, b float, c char(5), d varchar, e smallint);
create index i_t_abcd on t(a,b,c,d);

insert into t values (1,1.1, 'AAAAA', 'AAAAA', 1);
insert into t values (1,1.1, 'AAAAA', 'AABBB', -1);
insert into t values (1,null, null, null, null);
insert into t values (2,2.1, 'BBBBB', 'BBBBB', 2);

select /*+ recompile use_desc_idx */ c,d,max(e),count(*) from t where a=1  and c like 'AAA%' group by b desc,c desc,d desc;

select /*+ recompile use_desc_idx */ c,d,max(e),count(*) from t where a=1  and c like 'AAA%' group by b desc,c desc,d desc using index i_t_abcd keylimit 0,1;

select /*+ recompile use_desc_idx */ c,d,max(e),count(*) from t where a=1  and c like 'AAA%' group by b desc,c desc,d desc using index i_t_abcd keylimit 1,1;


select /*+ recompile use_desc_idx */ c,d,max(e),count(*) from t where a=1  and c ='AABBB' group by b desc,d desc;

--we expect skipping GROUP BY.
select /*+ recompile */ a,b,c,d,count(*) from t where a=1 and c ='AAAAA' group  by b,d;

drop table t;

commit;
--+ holdcas off;
