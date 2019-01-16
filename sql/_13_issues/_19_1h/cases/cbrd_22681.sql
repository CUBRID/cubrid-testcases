drop table if exists t1;
create table t1 (a varchar(10));
insert into t1 values ('a');

--test: Segmentation fault which is not expected.
select t1.s collate iso88591_en_ci from t1;

drop table if exists t1;
