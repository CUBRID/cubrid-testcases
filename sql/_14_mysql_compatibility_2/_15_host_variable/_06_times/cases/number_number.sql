--- number + number = number (native)


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (4,2,2);
--- table columns
select d1*i1 from t1;
select d1*n1 from t1;
select i1*n1 from t1;

--prepared statements
-- double column 
prepare st from 'select ? * d1 from t1';
execute st using 8;
deallocate prepare st;

prepare st from 'select d1 * ? from t1';
execute st using 2;
deallocate prepare st;

prepare st from 'select ? * d1 from t1';
execute st using 8.0e0;
deallocate prepare st;

prepare st from 'select d1 * ? from t1';
execute st using 2.0e0;
deallocate prepare st;

-- int column 
prepare st from 'select i1 * ? from t1';
execute st using 1;
deallocate prepare st;

prepare st from 'select ? * i1 from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select i1 * ? from t1';
execute st using 0.1e1;
deallocate prepare st;

prepare st from 'select ? * i1 from t1';
execute st using 0.4e1;
deallocate prepare st;

-- numeric
prepare st from 'select n1 * ? from t1';
execute st using 1;
deallocate prepare st;

prepare st from 'select ? * n1 from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select n1 * ? from t1';
execute st using 1.0;
deallocate prepare st;

prepare st from 'select ? * n1 from t1';
execute st using 0.4e1;
deallocate prepare st;


-- overflow by zero
truncate table t1;
insert into t1 values (2.0e130,123456789,1234567.89);

prepare st from 'select n1 * ?  from t1';
execute st using  12345678901234567890123456789.123456;
deallocate prepare st;

prepare st from 'select n1 * ?  from t1';
execute st using 12345678901234567890.1234567890e0;
deallocate prepare st;

prepare st from 'select i1 * ? from t1';
execute st using 123456789;
deallocate prepare st;

prepare st from 'select i1 * ? from t1';
execute st using 123456789e0;
deallocate prepare st;

prepare st from 'select d1 * ? from t1';
execute st using 2.0e130;
deallocate prepare st;

drop table t1;


select 4 * 2.0;

select 4 * 2;

select 4 * 0.2e1;

select 4 * 0e0;

select 4 * 0.0;

select 4 * 0;

prepare st from 'select 4 * ?';
execute st using 2;
deallocate prepare st;

prepare st from 'select ? * 0.2e1';
execute st using 4;
deallocate prepare st;


prepare st from 'select ? * ?';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select ? * ?';
execute st using 4,2.0;
deallocate prepare st;


