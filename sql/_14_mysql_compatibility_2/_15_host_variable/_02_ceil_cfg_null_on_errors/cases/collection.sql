--+ holdcas on;
--- collection
set system parameters 'return_null_on_function_errors=yes';

prepare st from 'select ceil(?)';
execute st using {12,12.2};

create table t1 (s1 set(int, double));

insert into t1 values ({123,1.12312e1});
select ceil(s1) from t1;

drop table t1;

select ceil({12,12.2});

set system parameters 'return_null_on_function_errors=no';commit;
--+ holdcas off;
