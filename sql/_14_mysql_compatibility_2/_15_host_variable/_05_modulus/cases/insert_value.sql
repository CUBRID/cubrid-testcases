create table t1 (a integer auto_increment, i1 integer, s1 varchar(10), d1 double, c1 set(int));

-- expected domain = int
prepare st from 'insert into t1(i1) values ( mod (? , ?))';
execute st using 5, 3;
deallocate prepare st;

prepare st from 'insert into t1(i1) values ( mod (? , ?))';
execute st using 5, '3';
deallocate prepare st;

prepare st from 'insert into t1(i1) values ( mod (? , ''3''))';
execute st using 5;
deallocate prepare st;

prepare st from 'insert into t1(i1) values ( mod (? , ?))';
execute st using '5', '3.2';
deallocate prepare st;

-- cannot coerce
prepare st from 'insert into t1(i1) values ( mod (? , ?))';
execute st using 'a','b';
deallocate prepare st;

-- overflow
prepare st from 'insert into t1(i1) values ( mod (? , ?))';
execute st using 31234567890.3 , 1;
deallocate prepare st;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = varchar
prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using 5,3;
deallocate prepare st;

prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using '5',3;
deallocate prepare st;

prepare st from 'insert into t1(s1) values ( mod (? , 3))';
execute st using '5';
deallocate prepare st;

prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using '5','3.2';
deallocate prepare st;

prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using 'a',2;
deallocate prepare st;

-- overflow
prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using 1234567890 , 0;
deallocate prepare st;

prepare st from 'insert into t1(s1) values ( mod (? , ?))';
execute st using '1234567890', '0';
deallocate prepare st;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = date
prepare st from 'insert into t1(d1) values ( mod (? , ?))';
execute st using '5',3;
deallocate prepare st;

prepare st from 'insert into t1(d1) values ( mod (? , ?))';
execute st using 5.0,3;
deallocate prepare st;


select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = set
prepare st from 'insert into t1(c1) values (mod (? , ?))';
execute st using {4},{'2'};
deallocate prepare st;

prepare st from 'insert into t1(c1) values (mod (? , ?))';
execute st using {4},{2};
deallocate prepare st;

select * from t1 order by 1,2,3,4;

drop table t1;
