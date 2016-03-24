--create table with enum type column in various forms.
--+ holdcas on;

drop table if exists t1;
--all the following statements should be ok until the end of the scenario file
create table t1 (i int, e1 enum(_utf8'A', _utf8'B'));
show full columns from t1;

insert into t1 values (1, _utf8'A'), (2, _utf8'B');
select * from t1 order by i,e1;
drop table t1;

create table t1 (i int, e1 enum(_iso88591'A', _iso88591'B'));
show full columns from t1;

insert into t1 values (1, _iso88591'A'), (2, _iso88591'B');
select * from t1 order by i,e1;
drop table t1;

create table t1 (i int, e1 enum(_euckr'A', _euckr'B'));
show full columns from t1;

insert into t1 values (1, _euckr'A'), (2, _euckr'B');
select * from t1 order by i,e1;
drop table t1;

commit;
--+ holdcas off;
