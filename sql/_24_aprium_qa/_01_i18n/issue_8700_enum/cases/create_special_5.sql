--create table with enum type column in various forms.
--+ holdcas on;
set names utf8;

drop table if exists t1;
create table t1 (i int, e1 enum('A', 'B') collate utf8_en_ci);
show full columns from t1;

insert into t1 values (1, 'A'), (2, 'a'), (3, 'B'), (4, 'b');

create table t2 as select i, e1 from t1;
show full columns from t2;
select * from t2, order by 1, 2;
drop table t2;

insert into t1 values (5, _iso88591'A');
insert into t1 values (6, _iso88591'B');
insert into t1 values (7, _euckr'A');
select * from t1 order by 1, 2;

drop table t1;

set names iso88591;
commit;
--+ holdcas off;
