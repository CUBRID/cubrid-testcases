--+ holdcas on;
set system parameters 'plus_as_concat=no';

create table t1 (a integer auto_increment, i1 integer, s1 varchar(10), d1 date, c1 set(int));

-- expected domain = int

prepare st from 'insert into t1(i1) values (? + ?)';
execute st using -3, '4';

prepare st from 'insert into t1(i1) values (? + ''4'')';
execute st using -3;

prepare st from 'insert into t1(i1) values (? + ?)';
execute st using '-3', '4.1';

-- cannot coerce
prepare st from 'insert into t1(i1) values (? + ?)';
execute st using 'a','b';


select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = varchar
prepare st from 'insert into t1(s1) values (? + ?)';
execute st using 1,2;

prepare st from 'insert into t1(s1) values (? + ?)';
execute st using '1',2;

prepare st from 'insert into t1(s1) values (? + 2)';
execute st using '1';

prepare st from 'insert into t1(s1) values (? + ?)';
execute st using '1','2.3';

prepare st from 'insert into t1(s1) values (? + ?)';
execute st using 'a',2;

-- overflow
prepare st from 'insert into t1(s1) values (? + ?)';
execute st using 1234567890 , 1;

prepare st from 'insert into t1(s1) values (? + ?)';
execute st using '1234567890', '1';

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = date
prepare st from 'insert into t1(d1) values (? + ?)';
execute st using date'2001-10-11',4;

prepare st from 'insert into t1(d1) values (? + 4)';
execute st using date'2001-10-11';

prepare st from 'insert into t1(d1) values (? + ?)';
execute st using 2,2.2;

prepare st from 'insert into t1(d1) values (? + ?)';
execute st using '2001-10-11',4;

prepare st from 'insert into t1(d1) values (? + ?)';
execute st using '2001-10-1','4';

select * from t1 order by 1,2,3,4;

drop prepare st;
drop table t1;

set system parameters 'plus_as_concat=yes';commit;
--+ holdcas off;
