create table t1 (s1 string collate utf8_en_ci);
create table t2 (s1 string collate utf8_tr_cs);

insert into t1 values ('aa'), ('Ab');

insert into t2 values ('aa'), ('Ab');



--select s1 + user() from t1 order by 1;
--select s1 + user() from t2 order by 1;





drop table t1;
drop table t2;
