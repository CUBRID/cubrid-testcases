-- number / string
create table t1 (s1 varchar(10),sn1 nchar varying(10), i2 int);

insert into t1 values ('4',n'4',2);
insert into t1 values (NULL,n'4',2);
insert into t1 values ('4',n'2',NULL);
insert into t1 values ('4a',n'2',2);
insert into t1 values ('4',n'2a',2);
select s1,sn1,i2,s1/i2 from t1 order by 1,2,3,4;
select s1,sn1,i2,i2/sn1 from t1 order by 1,2,3,4;
select s1,sn1,i2,s1/sn1 from t1 order by 1,2,3,4;
truncate table t1;



-- columns with HV
insert into t1 values ('4',n'4',2);

prepare st from 'select ? / i2 from t1'
execute st using '4';

prepare st from 'select ? / i2 from t1'
execute st using NULL;

prepare st from 'select i2 / ? from t1'
execute st using n'1';

prepare st from 'select s1 / ? from t1'
execute st using 0.2e1;

prepare st from 'select ? / sn1 from t1'
execute st using 8.4;

prepare st from 'select s1 / ? from t1'
execute st using NULL;

prepare st from 'select s1 / ? from t1'
execute st using 0;

drop table t1;

-- constants
select '2001-10-11' / 4;

select 4/ '2';

select 4 / 'abc';

select 4 / NULL;

select 4 / 0;


-- 2 HV
prepare st from 'select ? / ?'
execute st using '2001-10-11',4;

prepare st from 'select ? / ?'
execute st using 4,'abc';

prepare st from 'select ? / ?'
execute st using 4,'2';

prepare st from 'select ? / ?'
execute st using 4,NULL;

prepare st from 'select ? / ?'
execute st using 4,2;

prepare st from 'select ? / ?'
execute st using 4.0,2;

-- divide by zero
prepare st from 'select ? / ?'
execute st using '4',0;

-- 1 HV
prepare st from 'select 4 / ?'
execute st using '2';

prepare st from 'select 4 / ?'
execute st using 2.0;

prepare st from 'select ? / ''2'''
execute st using 4;



