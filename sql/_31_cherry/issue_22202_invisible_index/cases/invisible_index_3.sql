drop table if exists t;
create class t (i int); insert into t values (1);
insert into t values (1); 
create index i_t_i on t (i) invisible; 
--@queryplan
select distinct * from t where i > 0 using index i_t_i(+) order by 1;
--@queryplan
select distinct * from t where i > 0 order by 1;                     
alter index i_t_i on t visible;    
--@queryplan
select distinct * from t where i > 0 using index i_t_i(+) order by 1;
--@queryplan
select distinct * from t where i > 0 order by 1;                     
drop table if exists t;

