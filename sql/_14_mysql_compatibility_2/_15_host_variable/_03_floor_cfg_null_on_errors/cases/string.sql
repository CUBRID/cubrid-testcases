--+ holdcas on;
--- string 

set system parameters 'return_null_on_function_errors=yes';

create table t1 (s1 varchar(20), sn1 nchar varying(20));

insert into t1 values (2.00123e1,3);
select floor(s1) from t1;
select floor(sn1) from t1;

truncate table t1;
insert into t1 values ('asd',n'asd');
select floor(s1) from t1;
select floor(sn1) from t1;

drop table t1;

select (floor('123'));

select (floor(n'123'));

select (floor('asd'));

select (floor(n'asd'));

prepare st from 'select floor(?)';
execute st using '2001-10-11';

prepare st from 'select floor(?)';
execute st using '2001';

prepare st from 'select floor(?)';
execute st using '2.0011e1';

prepare st from 'select floor(?)';
execute st using '2001.12';

prepare st from 'select floor(?)';
execute st using 'asd';

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
