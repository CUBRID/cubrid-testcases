--- date + number  = date 		(cast number to INT)
--+ holdcas on;
set system parameters 'return_null_on_function_errors=yes';

create table t1 (d1 date, i2 int, f3 float);

insert into t1 values (date'2001-10-11',20,2.0123e1);
select d1+i2 from t1;
select d1+f3 from t1;


prepare st from 'select ? + i2 from t1';
execute st using date'2001-10-11';

prepare st from 'select f3 + ? from t1';
execute st using date'2001-10-11';

prepare st from 'select i2 + ? from t1';
execute st using date'2001-10-11';


prepare st from 'select d1 + ? from t1';
execute st using 4;

prepare st from 'select ? + d1 from t1';
execute st using 0.12123e1;


drop table t1;


select date'2001-10-11' + 20;

select date'2001-10-11' + 2.01e1;

prepare st from 'select ? + ?';
execute st using 4,date'2001-10-11';

prepare st from 'select ? + ?';
execute st using 4.3,date'2001-10-11';

prepare st from 'select ? + ?';
execute st using 4e113,date'2001-10-11';

prepare st from 'select 4 + ?';
execute st using date'2001-10-11';

prepare st from 'select ? + 4';
execute st using date'2001-10-11';

prepare st from 'select ? + date''2001-01-11''';
execute st using 4;

prepare st from 'select ? + date''2001-01-11''';
execute st using 4.123;
drop prepare st;

set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
