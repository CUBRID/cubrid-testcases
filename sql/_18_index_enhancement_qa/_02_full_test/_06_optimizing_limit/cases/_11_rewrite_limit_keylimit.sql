--+ holdcas on;
create table t (i int);

insert into t values (1);
insert into t values (2);
insert into t values (3);
                                                                                                                                                                                                                      
create index i_t_i on t(i);

set system parameters 'xasl_debug_dump=yes';
--CUBRIDSUS-4802(IE)
select /*+ recompile */ t.i,rownum  from t where i>0  using index i_t_i keylimit 1,3 order by i limit 0,2;

set system parameters 'xasl_debug_dump=no';

drop table t;

commit;
--+ holdcas off;
