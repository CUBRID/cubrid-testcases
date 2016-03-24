create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_tr_cs);

create table tf (f_iso string collate iso88591_en_cs, f_utf8 string collate utf8_en_cs);

insert into t1 values ('10:11'), ('10:12');

insert into t2 values ('10:11'), ('10:12');

insert into tf values ('%H _%p','%H _%p');




select time_format (s1,'%H _%p') from t1 order by 1;
select time_format (s1,'%H _%p') from t2 order by 1;


select time_format (cast (s1 as string collate utf8_en_cs),'%H _%p') from t1 order by 1;
select time_format (cast (s1 as string collate utf8_en_ci),'%H _%p') from t2 order by 1;

select time_format (cast (s1 as string collate utf8_en_cs),'%H _%p') from t1 order by 1;
select time_format (cast (s1 as string collate utf8_en_ci),'%H _%p') from t2 order by 1;

select time_format (t1.s1, tf.f_iso) from t1,tf order by 1;

select time_format (t1.s1, tf.f_utf8) from t1,tf order by 1;

-- late binding
prepare s from 'select time_format(s1, ?) from t1 order by 1'
execute s using '%H _%p';

prepare s from 'select time_format(s1, ?) from t2 order by 1'
execute s using '%H _%p';



drop table t1;
drop table t2;
drop table tf;
