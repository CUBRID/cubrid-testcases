--+ holdcas on;
--- date

set system parameters 'return_null_on_function_errors=yes';

create table t1 (d1 date);

insert into t1 values (date'2001-10-11');
select floor(d1) from t1;

drop table t1;



select floor(date'2001-10-10');

prepare st from 'select floor(?)';
execute st using date'2001-10-11';

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
