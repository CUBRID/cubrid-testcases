-- number - string
create table t1 (s1 varchar(10),sn1 nchar varying(10), i2 int);

insert into t1 values ('10',n'10',3);
insert into t1 values (NULL,n'10',3);
insert into t1 values ('10',NULL,3);
insert into t1 values ('10',n'10',NULL);
select s1,sn1,i2,s1-i2 from t1 order by 1,2,3,4;
select s1,sn1,i2,i2-sn1 from t1 order by 1,2,3,4;
truncate table t1;

insert into t1 values ('2001-10-11',n'2001-10-11',3);
select s1-i2 from t1;
select i2-sn1 from t1;
truncate table t1;

insert into t1 values ('2001abc',n'2001abc',3);
select i2-s1 from t1;
select sn1-i2 from t1;
truncate table t1;


-- columns with HV
insert into t1 values ('10',n'10',3);

prepare st from 'select ? - i2 from t1';
execute st using '2001';
deallocate prepare st;

prepare st from 'select ? - i2 from t1';
execute st using NULL;
deallocate prepare st;

prepare st from 'select ? - i2 from t1';
execute st using n'2001';
deallocate prepare st;

prepare st from 'select s1 - ? from t1';
execute st using 0.123123e1;
deallocate prepare st;

prepare st from 'select ? - sn1 from t1';
execute st using 1.2;
deallocate prepare st;

prepare st from 'select s1 - ? from t1';
execute st using NULL;
deallocate prepare st;

drop table t1;

-- constants
select '2001-10-11' - 4;

select n'2001-10-11' - 4;

select 2123456789 - '2123456789';

select 2123456789 - n'2123456789';

select 2123456789 - 'abc';

select 2123456789 - NULL;


-- 2 HV
prepare st from 'select ? - ?';
execute st using '2001-10-11',4;
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using 4,'2001-10-11';
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using 4,'abc';
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using 'abc',4;
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using 4,'123';
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using 4,NULL;
deallocate prepare st;

-- 1 HV
prepare st from 'select ? - 4';
execute st using '2001';
deallocate prepare st;

prepare st from 'select 4.321 - ?';
execute st using '2001';
deallocate prepare st;

prepare st from 'select ? - ''2001''';
execute st using 4;
deallocate prepare st;

prepare st from 'select ''2001'' - ?';
execute st using 0.123123e1;
deallocate prepare st;

prepare st from 'select ? - 4';
execute st using n'2001';
deallocate prepare st;

prepare st from 'select n''2001'' - ?';
execute st using 0.123123e1;
deallocate prepare st;

prepare st from 'select n''2001-10-11'' - ?';
execute st using 0.123123e1;
deallocate prepare st;

-- overflow
prepare st from 'select ? - ?';
execute st using '222123456789',213456789;

drop prepare st;
