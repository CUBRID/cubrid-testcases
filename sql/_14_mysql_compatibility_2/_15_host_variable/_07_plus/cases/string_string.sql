--- string + string = string
create table t1 (s1 varchar(10), s2 char(10));

insert into t1 values ('2001-10-11','10:11:12');
select s1+s2 from t1;
truncate table t1;

-- col + HV
insert into t1 values ('2001-10-11','10:11:12');
insert into t1 values ('1','2');

prepare st from 'select s1 + ? from t1 ORDER BY 1';
execute st using '2001-10-11';

prepare st from 'select ? + s2 from t1 ORDER BY 1';
execute st using '2';

prepare st from 'select ? + s2 from t1 ORDER BY 1';
execute st using NULL;

drop table t1;


-- 2HV
prepare st from 'select ? + ?';
execute st using '2001-10-11','2001-10-11';


prepare st from 'select ? + ?';
execute st using n'2001-10-11','2001-10-11';

prepare st from 'select ? + ?';
execute st using '10','2001-10-11';

prepare st from 'select ? + ?';
execute st using '10',NULL;

prepare st from 'select ? + ?';
execute st using NULL,NULL;


-- 1 HV
prepare st from 'select ? + ''asd''';
execute st using '2001-10-11';

prepare st from 'select ? + ''asd''';
execute st using '2001-10-11';

prepare st from 'select ''1'' + ?';
execute st using '2';

prepare st from 'select ''1'' + ?';
execute st using n'2';

prepare st from 'select ''1'' + ?';
execute st using NULL;

prepare st from 'select NULL + ?';
execute st using '2';

drop prepare st;
