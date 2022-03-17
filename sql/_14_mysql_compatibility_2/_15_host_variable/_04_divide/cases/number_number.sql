--- number + number = number (native)


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (4,2,2);
--- table columns
select d1/i1 from t1;
select d1/n1 from t1;
select i1/n1 from t1;

--prepared statements
-- double column 
prepare st from 'select ? / d1 from t1';
execute st using 8;

prepare st from 'select d1 / ? from t1';
execute st using 2;

prepare st from 'select ? / d1 from t1';
execute st using 8.0e0;

prepare st from 'select d1 / ? from t1';
execute st using 2.0e0;

-- int column 
prepare st from 'select i1 / ? from t1';
execute st using 1;

prepare st from 'select ? / i1 from t1';
execute st using 4;

prepare st from 'select i1 / ? from t1';
execute st using 0.1e1;

prepare st from 'select ? / i1 from t1';
execute st using 0.4e1;

-- numeric
prepare st from 'select n1 / ? from t1';
execute st using 1;

prepare st from 'select ? / n1 from t1';
execute st using 4;

prepare st from 'select n1 / ? from t1';
execute st using 1.0;

prepare st from 'select ? / n1 from t1';
execute st using 0.4e1;


-- divide by zero
truncate table t1;
insert into t1 values (2.e1,4,4.4);

prepare st from 'select n1 / ?  from t1';
execute st using 0;


prepare st from 'select i1 / ? from t1';
execute st using 0e0;

prepare st from 'select d1 / ? from t1';
execute st using 0.0;

drop table t1;


select 4 / 2.0;

select 4 / 2;

select 4 / 0.2e1;

select 4 / 0e0;

select 4 / 0.0;

select 4 / 0;

prepare st from 'select 4 / ?';
execute st using 2;

prepare st from 'select ? / 0.2e1';
execute st using 4;


prepare st from 'select ? / ?';
execute st using 4,2;

prepare st from 'select ? / ?';
execute st using 4,2.0;

-- divide by zero
prepare st from 'select ? / ?';
execute st using 4,0.0;
