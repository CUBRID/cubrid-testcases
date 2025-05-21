--- date
--+ holdcas on;

set system parameters 'return_null_on_function_errors=yes';

create table t1 (d1 date);

insert into t1 values (date'2001-10-11');
select round(d1,1) from t1;

select round(1.23,d1) from t1;

drop table t1;



select round(date'2001-10-10',1);

select round(1.123,date'2001-10-10');

prepare st from 'select round(?,?)';
execute st using date'2001-10-11',1;
deallocate prepare st;

prepare st from 'select round(?,?)';
execute st using 1.123,time'10:11:12';
deallocate prepare st;

set system parameters 'return_null_on_function_errors=no';

commit;
--+ holdcas off;
