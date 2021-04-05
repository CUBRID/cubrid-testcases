--+ holdcas on;

create table t (i int, j int, s varchar(100));

insert into t values (1,9,'one');
insert into t values (2,8,'two');
insert into t values (3,7,'three');
insert into t values (4,6,'four');
insert into t values (5,5,'five');
insert into t values (6,4,'six');
insert into t values (7,3,'seven');
insert into t values (8,2,'eight');
insert into t values (9,1,'nine');
                                                                                                                                                                                                                      
create index i_t_i on t(i);

select /*+ recompile */ t.*  from t where i>0  using index i_t_i keylimit 2,10 order by i desc limit 0,2;
--result is incorrect
select /*+ recompile */ t.*  from t where i>0  using index i_t_i keylimit 2,10 order by i desc limit 1,2;
select /*+ recompile */ t.*  from t where i>0  using index i_t_i keylimit 2,10 order by i desc limit 2,2;

select /*+ recompile */ t.*  from t where i>0  using index i_t_i keylimit 2,10 order by i desc limit 3,2;


drop table t;

commit;

--+ holdcas off;

