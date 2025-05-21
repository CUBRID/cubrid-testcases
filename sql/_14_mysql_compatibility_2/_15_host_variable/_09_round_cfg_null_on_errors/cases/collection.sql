--- collection
--+ holdcas on;

set system parameters 'return_null_on_function_errors=yes';

prepare st from 'select round(?,?)';
execute st using {12.2},1;
deallocate prepare st;

create table t1 (s1 set(double));

insert into t1 values ({1.12312e1});
select round(s1,1) from t1;

drop table t1;

select round({12.2},1);

set system parameters 'return_null_on_function_errors=no';

commit;
--+ holdcas off;
