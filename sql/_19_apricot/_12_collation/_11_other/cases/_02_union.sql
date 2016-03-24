
create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_en_cs);

insert into t1 values ('Ab'), ('aa');

insert into t2 values ('Ab'), ('aa'); 



select t1.s1 from t1 where t1.s1='aa' union all select t2.s1 from t2 where t2.s1='aa';



drop table t1;
drop table t2;
