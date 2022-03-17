--- string 
--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';

create table t1 (s1 varchar(20), sn1 nchar varying(20));

insert into t1 values (2.00123e1,3);
select abs(s1) from t1;
select abs(sn1) from t1;

truncate table t1;
insert into t1 values ('asd',n'asd');
select abs(s1) from t1;
select abs(sn1) from t1;

drop table t1;

select (abs('123'));

select (abs(n'123'));

select (abs('asd'));

select (abs(n'asd'));

prepare st from 'select abs(?)';
execute st using '2001-10-11';

prepare st from 'select abs(?)';
execute st using '2001';

prepare st from 'select abs(?)';
execute st using '2.0011e1';

prepare st from 'select abs(?)';
execute st using '2001.12';

prepare st from 'select abs(?)';
execute st using 'asd';

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
