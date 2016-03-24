--create table with enum type column in various forms.
--+ holdcas on;

drop table if exists t1;
create table t1 (i int, e1 enum(_utf8'A', _iso88591'B'));
show full columns from t1;
drop table t1;

create table t1 (i int, e1 enum(_utf8'A', _utf8'B') collate iso88591_bin);
show full columns from t1;
drop table t1;

create table t1 (i int, e1 enum(_iso88591'A', _iso88591'B') collate utf8_bin);
show full columns from t1;
drop table t1;

create table t1 (i int, e1 enum('A', 'B') collate utf8_bin);
show full columns from t1;
insert into t1 values (1, _iso88591'A');
insert into t1 values (1, _iso88591'B');
insert into t1 values (1, _euckr'A');
select * from t1 order by 1, 2;
drop table t1;

commit;
--+ holdcas off;
