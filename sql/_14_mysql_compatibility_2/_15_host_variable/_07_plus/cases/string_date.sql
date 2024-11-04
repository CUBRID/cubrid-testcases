--- string + date = string 		(native )
create table t1 (s1 varchar(10), d2 date);

insert into t1 values ('2001-10-11',date'2001-10-11');
select s1+d2 from t1;
truncate table t1;

insert into t1 values ('10',date'2001-10-11');
select s1+d2 from t1;
truncate table t1;

insert into t1 values ('1.123e1',date'2001-10-11');
select s1+d2 from t1;
truncate table t1;

insert into t1 values ('abc',date'2001-10-11');
select s1+d2 from t1;
truncate table t1;

insert into t1 values (NULL,date'2001-10-11');
select s1+d2 from t1;
truncate table t1;

insert into t1 values ('abc',NULL);
select s1+d2 from t1;
truncate table t1;


-- columns , HV
insert into t1 values ('abc',date'2001-10-11');

prepare st from 'select s1 + ? from t1';
execute st using date'2001-10-11';
deallocate prepare st;

prepare st from 'select ? + d2 from t1';
execute st using n'abc';
deallocate prepare st;

prepare st from 'select s1 + ? from t1';
execute st using NULL;
deallocate prepare st;

truncate table t1;
insert into t1 values (NULL,date'2001-10-11');
insert into t1 values ('abc',NULL);

prepare st from 'select s1 + ? from t1';
execute st using NULL;
deallocate prepare st;

prepare st from 'select ? + d2 from t1';
execute st using NULL;
deallocate prepare st;

drop table t1;

-- constants
select '2001-10-11' + date'2001-10-11';

select '2001' + date'2001-10-11';

select 'abc' + date'2001-10-11';

select time'10:11:12' + n'abc';

select timestamp'2001-10-11 10:11:12' + n'10';

select NULL + date'2001-10-11';

-- 2 HV
prepare st from 'select ? + ?';
execute st using '34',date'2001-10-11';
deallocate prepare st;

prepare st from 'select ? + ?';
execute st using date'2001-10-11','34';
deallocate prepare st;

prepare st from 'select ? + ?';
execute st using NULL,'34';
deallocate prepare st;

prepare st from 'select ? + ?';
execute st using '34',NULL;
deallocate prepare st;

prepare st from 'select ? + ?';
execute st using n'34',time'10:11:12';
deallocate prepare st;

-- 1 HV
prepare st from 'select ''34'' + ?';
execute st using date'2001-10-11';
deallocate prepare st;

prepare st from 'select time''10:11:12'' + ?';
execute st using n'2';
deallocate prepare st;

prepare st from 'select time''10:11:12'' + ?';
execute st using NULL;

drop prepare st;
