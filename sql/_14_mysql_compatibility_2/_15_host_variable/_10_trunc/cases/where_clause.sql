create table t1 (i1 integer, s1 varchar(10), d1 double, c1 set(int));

insert into t1 values (3,'3.12',3.12e0,{3});

prepare st from 'select * from t1 where i1=trunc(?,0)';
execute st using 3.123;
deallocate prepare st;

prepare st from 'select * from t1 where i1=trunc(?,?)';
execute st using '3.123',0.1;
deallocate prepare st;

prepare st from 'select * from t1 where d1=trunc(?,2)';
execute st using 3.1234e0;
deallocate prepare st;

prepare st from 'select * from t1 where c1={trunc(?,1)}';
execute st using 3.123;
deallocate prepare st;

prepare st from 'select * from t1 where trunc(?,?) in c1';
execute st using 3.123,0.0e0;
deallocate prepare st;


drop table t1;


prepare st from 'select 1 from db_root where 3=trunc(?,1)';
execute st using 3.123;
deallocate prepare st;

prepare st from 'select 1 from db_root where 3.1=trunc(?,1)';
execute st using 3.123;
deallocate prepare st;

prepare st from 'select 1 from db_root where 3.1=trunc(?,1)';
execute st using 3.123;
deallocate prepare st;

prepare st from 'select 1 from db_root where ''3''=trunc(?,?)';
execute st using 3.123,0;
deallocate prepare st;

prepare st from 'select 1 from db_root where ''3''=trunc(3,?)';
execute st using 1;
deallocate prepare st;
