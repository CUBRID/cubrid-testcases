-- [er]create unique index on which create table using int  and then query distinct  values and using ">" operator and index

create class t (i int); insert into t values (1);
 insert into t values (1); create unique index i_t_i on t (i); 
select distinct * from t where i > 0 using index i_t_i(+) order by 1; 
drop t;
rollback;
rollback;
