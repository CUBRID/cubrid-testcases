--+ holdcas on;
--- mod (string , string)

set system parameters 'return_null_on_function_errors=yes';


create table t1 (s1 varchar(10), s2 char(10));

insert into t1 values ('2001-10-11','2');
insert into t1 values ('4','2');
select s1,s2, mod(s1,s2) from t1 order by 1,2,3;

truncate table t1;

-- col / HV
insert into t1 values ('2001-10-11','2');
insert into t1 values ('4','2');
insert into t1 values ('4','0');

prepare st from 'select s1,s2, mod (s1 , ?) from t1 order by 1,2';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select s1,s2, mod (? , s2) from t1 order by 1,2';
execute st using '2';
deallocate prepare st;

prepare st from 'select s1,s2, mod (? , s2) from t1 order by 1,2';
execute st using NULL;
deallocate prepare st;

drop table t1;


-- 2HV
prepare st from 'select mod (? , ?)';
execute st using '2001-10-11','2';
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using '4','a';
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using '4',NULL;
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using NULL,'2';
deallocate prepare st;

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
