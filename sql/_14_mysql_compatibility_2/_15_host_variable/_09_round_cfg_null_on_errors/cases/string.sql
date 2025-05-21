--- string 
--+ holdcas on;

set system parameters 'return_null_on_function_errors=yes';

create table t1 (s1 varchar(20), sn1 nchar varying(20));

insert into t1 values ('2.1236',n'3.1234');
--select round(s1,sn1) from t1;
--select round(sn1,s1) from t1;

truncate table t1;

insert into t1 values ('asd',n'asd');
select round(s1,1) from t1;
select round(2.23,sn1) from t1;

drop table t1;

select round('1.123',1);

select round('123','1');

select round(n'123','1.1');

select round('asd',1);

select round(1.523,n'1');

-- 2HV
--prepare st from 'select round(?,?)'
--execute st using '2.1234e0',3;

prepare st from 'select round(?,?)';
execute st using '1.123','2';
deallocate prepare st;

prepare st from 'select round(?,?)';
execute st using 'asd',2;
deallocate prepare st;

-- 1HV
prepare st from 'select round(?,1)';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select round(?,1)';
execute st using '1.1234';
deallocate prepare st;

prepare st from 'select round(1.123,?)';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select round(1.123,?)';
execute st using '1';
deallocate prepare st;

set system parameters 'return_null_on_function_errors=no';

commit;
--+ holdcas off;
