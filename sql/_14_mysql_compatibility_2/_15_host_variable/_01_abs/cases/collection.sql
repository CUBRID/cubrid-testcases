--- collection

prepare st from 'select abs(?)';
execute st using {12,12.2};
deallocate prepare st;

create table t1 (s1 set(int, double));
insert into t1 values ({123,1.12312e1});


select abs(s1) from t1;



drop table t1;


select abs({12,12.2});

