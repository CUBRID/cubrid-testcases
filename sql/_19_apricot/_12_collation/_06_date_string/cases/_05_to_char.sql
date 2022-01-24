create table t1 (d1 date);

create table tf (f_iso string collate iso88591_en_cs, f_utf8 string collate utf8_en_cs);

insert into t1 values (date'2001-11-12'), (date'2001-11-10');

insert into tf values ('DD MONTH YYYY Day','DD MONTH YYYY Day');


select to_char (d1) from t1 order by 1;

select to_char (d1,'DD MONTH YYYY Day','en_US') from t1 order by 1;
select to_char (d1,'DD MONTH YYYY Day','tr_TR') from t1 order by 1;

select to_char (d1,f_iso,'tr_TR') from t1,tf order by 1;
select to_char (d1,f_utf8,'tr_TR') from t1,tf order by 1;

prepare s from 'select to_char (d1,?,''en_US'') from t1 order by 1';
execute s using 'DD MONTH YYYY';

drop prepare s;
drop table t1;
drop table tf;
