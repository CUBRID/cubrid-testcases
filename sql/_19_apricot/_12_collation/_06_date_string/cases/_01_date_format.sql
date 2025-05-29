create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_tr_cs);

create table tf (f_iso string collate iso88591_en_cs, f_utf8 string collate utf8_en_cs);

insert into t1 values ('2001-11-12'), ('2001-11-10');

insert into t2 values ('2001-11-12'), ('2001-11-10');

insert into tf values ('%a','%a');

select date_format (s1,'%a') from t1 order by 1;
select date_format (s1,'%a') from t2 order by 1;


select date_format (cast (s1 as string collate utf8_en_cs),'%a') from t1 order by 1;
select date_format (cast (s1 as string collate utf8_en_ci),'%a') from t2 order by 1;

select date_format (cast (s1 as string collate utf8_en_cs),'%a') from t1 order by 1;
select date_format (cast (s1 as string collate utf8_en_ci),'%a') from t2 order by 1;

select date_format (t1.s1, tf.f_iso) from t1,tf order by 1;

select date_format (t1.s1, tf.f_utf8) from t1,tf order by 1;

-- late binding
prepare s from 'select date_format(s1, ?) from t1 order by 1'
execute s using '%a';

prepare s from 'select date_format(s1, ?) from t2 order by 1'
execute s using '%a';


drop prepare s;
drop table t1;
drop table t2;
drop table tf;
