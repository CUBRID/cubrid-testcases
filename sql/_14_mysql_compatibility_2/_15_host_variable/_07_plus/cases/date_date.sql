--- date + date  = NULL

create table t1 (d1 date, d2 date);

insert into t1 values (date'2001-10-11',date'2001-10-11');
select d1+d2 from t1;

prepare st from 'select ? + d1 from t1';
execute st using date'2001-10-11';

prepare st from 'select d1 + ? from t1';
execute st using date'2001-10-11';

drop table t1;



select date'2001-10-10' + date'2001-10-10';

prepare st from 'select ? + ?';
execute st using date'2001-10-11',date'2001-10-11';

prepare st from 'select ? + date''2001-10-11''';
execute st using date'2001-10-11';

prepare st from 'select date''2001-10-11'' + ?';
execute st using date'2001-10-11';
