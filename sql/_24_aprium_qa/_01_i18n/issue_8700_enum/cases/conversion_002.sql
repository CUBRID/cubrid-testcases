--conversion from enum to date/time types
--+ holdcas on;

drop table if exists t1;
create table t1(e1 enum('2011-01-01', '2012-01-01', '2010-04-05') collate utf8_en_cs);
show full columns from t1;

insert into t1 values (3), (1), (2);
select * from t1 order by 1;

select cast(e1 as timestamp) from t1 order  by 1;
select cast(e1 as datetime) from t1 order  by 1;
select cast(e1 as date) from t1 order  by 1;
select cast(e1 as time) from t1 order  by 1;

drop table t1;

create table t1(e1 enum('09:09:09', '10:10:10', '11:11:11 PM') collate utf8_en_ci);
show full columns from t1;

insert into t1 values (3), (1), (2);
select * from t1 order by 1;
select cast(e1 as time) from t1 order  by 1;
drop table t1;

commit;
--+ holdcas off;
