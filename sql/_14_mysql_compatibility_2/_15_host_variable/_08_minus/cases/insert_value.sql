create table t1 (a integer auto_increment, i1 integer, s1 varchar(9), d1 date, c1 set(int));

-- expected domain = int
prepare st from 'insert into t1(i1) values (? - ?)'
execute st using -3, 4;

prepare st from 'insert into t1(i1) values (? - ?)'
execute st using -3, '4';

prepare st from 'insert into t1(i1) values (? - ''4'')'
execute st using -3;

prepare st from 'insert into t1(i1) values (? - ?)'
execute st using '-3', '4.1';

-- cannot coerce
prepare st from 'insert into t1(i1) values (? - ?)'
execute st using 'a','b';

-- overflow
prepare st from 'insert into t1(i1) values (? - ?)'
execute st using 31234567890.3 , 31234567890.3;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = varchar
prepare st from 'insert into t1(s1) values (? - ?)'
execute st using 1,2;

prepare st from 'insert into t1(s1) values (? - ?)'
execute st using '1',2;

prepare st from 'insert into t1(s1) values (? - 2)'
execute st using '1';

prepare st from 'insert into t1(s1) values (? - ?)'
execute st using '1','2.1';

prepare st from 'insert into t1(s1) values (? - ?)'
execute st using 'a',2;

-- overflow
prepare st from 'insert into t1(s1) values (? - ?)'
execute st using 1234567890 , 1;

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = date
prepare st from 'insert into t1(d1) values (? - ?)'
execute st using date'2001-10-11',4;

prepare st from 'insert into t1(d1) values (? - 4)'
execute st using date'2001-10-11';

prepare st from 'insert into t1(d1) values (? - ?)'
execute st using 2,2.2;

prepare st from 'insert into t1(d1) values (? - ?)'
execute st using '2001-10-11',4;

prepare st from 'insert into t1(d1) values (? - ?)'
execute st using '2001-10-1','4';

select * from t1 order by 1,2,3,4;
truncate table t1;

-- expected domain = set
--prepare st from 'insert into t1(c1) values (? - ?)'
--execute st using {123},{'2'};

--prepare st from 'insert into t1(c1) values (? - ?)'
--execute st using {123},{2};

--prepare st from 'insert into t1(c1) values (? - ?)'
--execute st using {123},{'a'};

--select * from t1 order by 1,2,3,4;

drop table t1;
