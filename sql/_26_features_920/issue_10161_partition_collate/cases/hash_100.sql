SET NAMES utf8 COLLATE utf8_ko_cs_uca; 
create table t1(a varchar(100) charset utf8 collate utf8_ko_cs_uca, b int) PARTITION BY HASH (b) PARTITIONS 5;

insert into t1 values ('伽伽伽', 1);
insert into t1 values ('伽伽佳', 2);
insert into t1 values ('伽伽假', 3);
insert into t1 values ('佳伽伽', 4);
insert into t1 values ('假伽伽', 5);
insert into t1 values ('伽佳伽', 6);
insert into t1 values ('伽假伽', 7);
insert into t1 values ('佳假伽', 8);
insert into t1 values ('佳伽假', 9);
insert into t1 values ('伽佳假', 10);
insert into t1 values ('伽伽', 11);
insert into t1 values ('佳伽', 12);
insert into t1 values ('假伽', 13);
insert into t1 values ('伽佳', 14);
insert into t1 values ('伽假', 15);
insert into t1 values ('伽', 16);
insert into t1 values ('UE', 103);
insert into t1 values ('ü', 104);
insert into t1 values ('Ü', 105);

select * from t1 partition(p0) order by a,b;
select * from t1 partition(p1) order by a,b ;
select * from t1 partition(p2) order by a,b;
select * from t1 partition(p3 order by a,b;
select * from t1 partition(p4) order by a,b;
drop table t1;

set names iso88591;
create table w2(a int, b varchar(100) charset utf8 collate utf8_en_ci) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop table w2;

create table w2(a int, b varchar(100) charset utf8) PARTITION BY HASH (b) PARTITIONS 5;
insert into w2 select rownum, chr(rownum) from db_class x1, db_class x2 limit 127;
select count(*) from w2 partition(p0);
select count(*) from w2 partition(p1);
select count(*) from w2 partition(p2);
select count(*) from w2 partition(p3);
select count(*) from w2 partition(p4);
drop table w2;

set names iso88591;
