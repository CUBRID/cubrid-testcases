create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_tr_cs);

insert into t1 values ('10:11'), ('10:12');

insert into t2 values ('10:11'), ('10:12');


select time (s1) from t1 order by 1;
select time (s1) from t2 order by 1;

-- late binding
prepare s from 'select s1 + time(?) from t1 order by 1';
execute s using '2001-11-12';

prepare s from 'select s1 + time(?) from t2 order by 1';
execute s using '2001-11-12';


drop prepare s;
drop table t1;
drop table t2;
