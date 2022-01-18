--+ holdcas on;

drop table if exists t1;

create table t1 (a integer auto_increment, i1 integer, s1 varchar(10), d1 double, c1 set(int));

-- expected domain = int
prepare st from 'insert into t1(i1) values (abs(?))';
execute st using -3;

prepare st from 'insert into t1(i1) values (abs(?))';
execute st using -3.3;

prepare st from 'insert into t1(i1) values (abs(?))';
execute st using '-3.3';

-- cannot coerce
prepare st from 'insert into t1(i1) values (abs(?))';
execute st using 'a';

-- overflow
prepare st from 'insert into t1(i1) values (abs(?))';
execute st using -31234567890.3;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = varchar
prepare st from 'insert into t1(s1) values (abs(?))';
execute st using -3;

prepare st from 'insert into t1(s1) values (abs(?))';
execute st using -3.3;

prepare st from 'insert into t1(s1) values (abs(?))';
execute st using '-3.3';

-- overflow
prepare st from 'insert into t1(s1) values (abs(?))';
execute st using -123456789.1234566;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = date
prepare st from 'insert into t1(d1) values (abs(?))';
execute st using -3;

prepare st from 'insert into t1(d1) values (abs(?))';
execute st using -3.3;

prepare st from 'insert into t1(d1) values (abs(?))';
execute st using '-3.3';

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = set
prepare st from 'insert into t1(c1) values (abs(?))';
execute st using -3;

select * from t1 order by 1,2,3,4;

drop table t1;

--+ holdcas off;
commit;
