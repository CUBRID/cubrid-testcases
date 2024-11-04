--- number + number = number (native)


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (2.00123e1,3,100.21);
--- table columns
select d1+i1 from t1;
select d1+n1 from t1;
select i1+n1 from t1;

--prepared statements
-- double column 
prepare st from 'select ? + d1 from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select d1 + ? from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select ? + d1 from t1';
execute st using 0.12313e1;
deallocate prepare st;

prepare st from 'select d1 + ? from t1';
execute st using 0.12313e1;
deallocate prepare st;

-- int column 
prepare st from 'select i1 + ? from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select ? + i1 from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select i1 + ? from t1';
execute st using 0.12313e1;
deallocate prepare st;

prepare st from 'select ? + i1 from t1';
execute st using 0.12313e1;
deallocate prepare st;

-- numeric
prepare st from 'select n1 + ? from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select ? + n1 from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select n1 + ? from t1';
execute st using 0.12313e1;
deallocate prepare st;

prepare st from 'select ? + n1 from t1';
execute st using 0.12313e1;
deallocate prepare st;


-- overflow
truncate table t1;
insert into t1 values (2.00123e1,1999999999,9999999.999);

prepare st from 'select ? + n1 from t1';
execute st using 9999999.999;
deallocate prepare st;

prepare st from 'select ? + n1 from t1';
execute st using 0.12313e1;
deallocate prepare st;

prepare st from 'select ? + i1 from t1';
execute st using 1999999999;
deallocate prepare st;

prepare st from 'select ? + i1 from t1';
execute st using 1999999999.1;
deallocate prepare st;

prepare st from 'select ? + i1 from t1';
execute st using 0.123123e1;
deallocate prepare st;

drop table t1;


select 4 + 4.3;

select 4 + 4;

select 4 + 0.123123e1;

prepare st from 'select 4 + ?';
execute st using 4;
deallocate prepare st;

prepare st from 'select ? + 0.123123e1';
execute st using 4;
deallocate prepare st;


prepare st from 'select ? + ?';
execute st using 4,4;
deallocate prepare st;

prepare st from 'select ? + ?';
execute st using 4,4.3;
deallocate prepare st;

-- overflow
prepare st from 'select ? + ?';
execute st using 1223456789,1223456789;
deallocate prepare st;
