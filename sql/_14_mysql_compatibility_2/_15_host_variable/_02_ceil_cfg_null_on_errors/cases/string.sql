--- string 
--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';

create table t1 (s1 varchar(20), sn1 nchar varying(20));

insert into t1 values (2.00123e1,3);
select ceil(s1) from t1;
select ceil(sn1) from t1;

truncate table t1;
insert into t1 values ('asd',n'asd');
select ceil(s1) from t1;
select ceil(sn1) from t1;

drop table t1;

select (ceil('123'));

select (ceil(n'123'));

select (ceil('asd'));

select (ceil(n'asd'));

prepare st from 'select ceil(?)';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using '2001';
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using '2.0011e1';
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using '2001.12';
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using 'asd';
deallocate prepare st;

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
