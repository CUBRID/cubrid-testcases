create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(1,1.2,1);
insert into t1 values(1,1.2,1);
insert into t1 values(2,2.5,2);
insert into t1 values(2,2.5,2);
insert into t1 values(10,1.2e2,3);
insert into t1 values(10,1.2e2,3);
insert into t1 values(10,1.2e2,3);
insert into t1 values(20,2.5e2,4);


--- MIN, MAX
select d1,max(f1+2), min (i1-2.0) from t1 group by d1;

prepare st from 'select d1,max(f1+?), min (i1-?) from t1 group by d1';
execute st using 2,2.0;
deallocate prepare st;

-- AVG, SUM
select d1,avg(f1+2), sum (i1-2.0) from t1 group by d1;

prepare st from 'select d1,avg(f1+?), sum (i1-?) from t1 group by d1';
execute st using 2,2.0;
deallocate prepare st;

-- STDDEV, VARIANCE
select d1,stddev(f1+2), variance(i1-2.0) from t1 group by d1;

prepare st from 'select d1,stddev(f1+?), variance(i1-?) from t1 group by d1';
execute st using 2,2.0;
deallocate prepare st;

-- STDDEV_POP, VAR_POP
select d1,stddev_pop(f1+2), var_pop(i1-2.0) from t1 group by d1;

prepare st from 'select d1,stddev_pop(f1+?), var_pop(i1-?) from t1 group by d1';
execute st using 2,2.0;
deallocate prepare st;

-- STDDEV_SAMP, VAR_SAMP
select d1,stddev_samp(f1+2), var_samp(i1-2.0) from t1 group by d1;

prepare st from 'select d1,stddev_samp(f1+?), var_samp(i1-?) from t1 group by d1';
execute st using 2,2.0;
deallocate prepare st;

-- COUNT
select f1,count(i1+2.0) from t1 group by d1;

prepare st from 'select f1,count(i1+?) from t1 group by d1';
execute st using 2.0;
deallocate prepare st;

-- COUNT(*)
select f1+2,count(*) from t1 group by d1;

prepare st from 'select f1+?,count(*) from t1 group by d1';
execute st using 2;
deallocate prepare st;

-- BIT_AND
select f1,bit_and(i1+2), bit_or(i1-2), bit_xor(i1*1) from t1 group by d1;

prepare st from 'select f1,bit_and(i1+?), bit_or(i1-?), bit_xor(i1*?) from t1 group by d1';
execute st using 2,2,1;
deallocate prepare st;

-- error : input should be int
select f1,bit_xor(i1+2.2) from t1 group by d1;

prepare st from 'select f1,bit_xor(i1+?) from t1 group by d1';
execute st using 2.2;
deallocate prepare st;

-- GROUP_CONCAT
select f1,group_concat(i1+2.2 order by 1) from t1 group by d1;

prepare st from 'select f1,group_concat(i1+? order by 1) from t1 group by d1';
execute st using 2.2;
deallocate prepare st;

-- GROUPBY_NUM
select f1,sum(i1+2) from t1 group by d1 having groupby_num()<2;

prepare st from 'select f1,sum(i1+?) from t1 group by d1 having groupby_num()<2';
execute st using 2;
deallocate prepare st;

select f1,sum(i1+2) from t1 group by d1 having groupby_num()<4;
prepare st from 'select f1,sum(i1+?) from t1 group by d1 having groupby_num()<?';
execute st using 2,4;
deallocate prepare st;

drop table t1;
