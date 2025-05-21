create table t1 (i1 integer, s1 varchar(10), d1 double, c1 set(int));

insert into t1 values (3,'3.3',3.3,{3});

prepare st from 'select * from t1 where i1=-(?)';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select * from t1 where i1=-(?)';
execute st using '-3.3';
deallocate prepare st;

prepare st from 'select * from t1 where d1=-(?)';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select * from t1 where c1={-(?)}';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select * from t1 where c1={-(?)}';
execute st using -3;
deallocate prepare st;

prepare st from 'select * from t1 where -(?) in c1';
execute st using -3;
deallocate prepare st;

drop table t1;


prepare st from 'select 1 from db_root where 3=-(?)';
execute st using -3.3;
deallocate prepare st;

prepare st from 'select 1 from db_root where 3=-(?)';
execute st using -3;
deallocate prepare st;

prepare st from 'select 1 from db_root where ''3''=-(?)';
execute st using -3;
deallocate prepare st;

-- - (-3.3) = 3.3 != '3'
prepare st from 'select 1 from db_root where ''3''=-(?)';
execute st using -3.3;
deallocate prepare st;
