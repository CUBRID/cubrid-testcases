--- string - string = string
create table t1 (s1 varchar(10), s2 char(10));

insert into t1 values ('2001-10-11','10:11:12');
select s1-s2 from t1;
truncate table t1;

-- col - HV
insert into t1 values ('2001-10-11','10:11:12');
insert into t1 values ('1','2');

prepare st from 'select s1 - ? from t1';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select ? - s2 from t1 order by 1';
execute st using '2';
deallocate prepare st;

prepare st from 'select ? - s2 from t1';
execute st using NULL;
deallocate prepare st;

drop table t1;


-- 2HV
prepare st from 'select ? - ?';
execute st using '2001-10-11','2001-10-11';
deallocate prepare st;


prepare st from 'select ? - ?';
execute st using n'2001-10-11','2001-10-11';
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using '10','2001-10-11';
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using '10',NULL;
deallocate prepare st;

prepare st from 'select ? - ?';
execute st using NULL,NULL;
deallocate prepare st;


-- 1 HV
prepare st from 'select ? - ''asd''';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select ? - ''asd''';
execute st using '2001-10-11';
deallocate prepare st;

prepare st from 'select ''1'' - ?';
execute st using '2';
deallocate prepare st;

prepare st from 'select ''1'' - ?';
execute st using n'2';
deallocate prepare st;

prepare st from 'select ''1'' - ?';
execute st using NULL;
deallocate prepare st;

prepare st from 'select NULL - ?';
execute st using '2';
deallocate prepare st;
