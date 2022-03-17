--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';

create table t1 (a integer auto_increment, i1 integer, s1 varchar(10), d1 date, c1 set(int));

-- expected domain = int
prepare st from 'insert into t1(i1) values (round(?,?))';
execute st using -3.123,1.23;

prepare st from 'insert into t1(i1) values (round(?,1))';
execute st using -3.123;

prepare st from 'insert into t1(i1) values (round(?,1.1))';
execute st using '-3.123';

-- cannot coerce
prepare st from 'insert into t1(i1) values (round(?,1))';
execute st using 'a';

-- overflow
prepare st from 'insert into t1(i1) values (round(?,1))';
execute st using -31234567890.3;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = varchar
prepare st from 'insert into t1(s1) values (round(?,1))';
execute st using -3.123;

prepare st from 'insert into t1(s1) values (round(?,''1''))';
execute st using -3.123;

prepare st from 'insert into t1(s1) values (round(?,1.1))';
execute st using '-3.123';

-- overflow
prepare st from 'insert into t1(s1) values (round(?,?))';
execute st using -123456789.1234566,'1';

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = date
prepare st from 'insert into t1(d1) values (round(?,?))';
execute st using 3.123,1;

prepare st from 'insert into t1(d1) values (round(?,?))';
execute st using 3.123,'1.1';

prepare st from 'insert into t1(d1) values (round(?,?))';
execute st using '3.123',1.1e0;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = set
prepare st from 'insert into t1(c1) values (round(?,2))';
execute st using 3.1234;

select * from t1 order by 1,2,3,4;

drop table t1;

set system parameters 'return_null_on_function_errors=no';

commit;
--+ holdcas off;
