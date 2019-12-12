--TEST: The result is incorrect when binding an invalid value to the prepare statement 'select * from t limit ?'


create table t(a int);
insert into t values(1), (2), (3);

prepare st from 'select * from t limit ?';
execute st using -1000000000000;
execute st using 'abc';
execute st using -1;

deallocate prepare st;

drop table t;


