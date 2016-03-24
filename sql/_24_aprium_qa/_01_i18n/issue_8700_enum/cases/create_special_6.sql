--create table with enum type column in various forms.
--+ holdcas on;
set names utf8;

drop table if exists t1;
create table t1 (i1 int, coll_enum1 enum('A', 'B') collate utf8_en_ci);
show full columns from t1;

create table t2 (i2 int, coll_enum2 enum('a', 'b') collate utf8_en_ci);
show full columns from t2;

insert into t1 values (1, 'A'), (2, 'a'), (3, 'B'), (3, 'b');
select * from t1 order by 1;

insert into t2 values (1, 'A'), (2, 'a'), (3, 'B'), (3, 'b');
select * from t2 order by 1;

select * from t1, t2 where t1.i1 = t2.i2 and t1.coll_enum1=t2.coll_enum2 order by t1.i1,t1.coll_enum1; 

drop table t1;
drop table t2;

set names iso88591;
commit;
--+ holdcas off;
