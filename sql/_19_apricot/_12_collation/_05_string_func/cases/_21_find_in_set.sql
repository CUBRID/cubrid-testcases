create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

create table t3 (s1 string collate iso88591_en_cs);

insert into t1 values ('Abcd'), ('aaxx');

insert into t2 values ('Abcd'), ('aaxx');

insert into t3 values ('Abcd'), ('aaxx');


select s1,find_in_set (s1,'aa,ab') from t1 order by 1;
select s1,find_in_set (s1,'aa,ab') from t2 order by 1;


-- late binding
prepare s from 'select find_in_set(? , ?)';
execute s using 'aa','aa,ab';
deallocate prepare s;


prepare s from 'select s1, find_in_set(s1 , ?) from t1 order by 1';
execute s using 'aa,ab';
deallocate prepare s;

prepare s from 'select s1, find_in_set(s1 , ?) from t2 order by 1';
execute s using 'aa,ab';
deallocate prepare s;

select t1.s1,t2.s1,find_in_set (t1.s1,t2.s1) from t1,t2 order by 1,2,3;

select t1.s1,t3.s1,find_in_set (t1.s1,t3.s1) from t1,t3 order by 1,2,3;

drop table t1;
drop table t2;
drop table t3;
