
--- number
create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (2.00123e0,3,100.1234);
select trunc(d1,i1) from t1;
select trunc(n1,i1) from t1;
select trunc(i1,2) from t1;

prepare st from 'select trunc(d1,?) from t1';
execute st using 2;
deallocate prepare st;

prepare st from 'select trunc(n1,?) from t1';
execute st using 2.2;
deallocate prepare st;

prepare st from 'select trunc(?,i1) from t1';
execute st using 2.1234567;
deallocate prepare st;

prepare st from 'select trunc(?,d1) from t1';
execute st using 2.1234567e0;
deallocate prepare st;


drop table t1;


-- constants
select trunc(4,1);

select trunc(4.123,2);

select trunc(4.123f,2.0f);

select trunc(4.1234e0,2);

select trunc(4.1234e0,2.0);



-- 2 HV
prepare st from 'select trunc(?,?)';
execute st using 4,1;
deallocate prepare st;

prepare st from 'select trunc(?,?)';
execute st using 4.12,1;
deallocate prepare st;

prepare st from 'select trunc(?,?)';
execute st using 4.12,1e0;
deallocate prepare st;

prepare st from 'select trunc(?,?)';
execute st using 4,1.0e0;
deallocate prepare st;

prepare st from 'select trunc(?,?)';
execute st using 4.001123e0,4.1;
deallocate prepare st;

-- 1 HV

prepare st from 'select trunc(?,4.1)';
execute st using 4.001123e0;
deallocate prepare st;

prepare st from 'select trunc(?,4.1e0)';
execute st using 4.001123;
deallocate prepare st;

prepare st from 'select trunc(4.01234,?)';
execute st using 4;
deallocate prepare st;

prepare st from 'select trunc(4.01234,?)';
execute st using 4.001123e0;
deallocate prepare st;


