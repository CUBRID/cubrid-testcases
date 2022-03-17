--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
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

set system parameters 'xasl_debug_dump=yes';

prepare st from 'select /*+ recompile */ t.*,rownum  from t where i>0 and rownum<=?';
execute st using 2;
deallocate prepare st;                                                       

--rownum value should be reverse order
prepare st from 'select /*+ recompile */ t.*,rownum  from t where i>0 and rownum<=? order by i desc';
execute st using 2;
deallocate prepare st;                                                       

select /*+ recompile */ t.*,rownum  from t where i>0 and rownum<=2 order by i desc;
select /*+ recompile */ 1  from t where i>0 and rownum<=2 using index none order by i desc;

select /*+ recompile */ t.*,rownum  from t where i>0 and rownum<=2 using index i_t_i keylimit 2,2 order by i desc;
select /*+ recompile */ t.*,rownum  from t where i>0 and rownum<=2 using index i_t_i keylimit 2,2 order by i asc;

set system parameters 'xasl_debug_dump=no';

drop table t;



set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
