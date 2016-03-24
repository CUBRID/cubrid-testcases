--+ holdcas on;
set names utf8;
select repeat('今天明天',1);

select repeat('Ğü',2);

select repeat('Ğu',3);

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_gen);
insert into t1 values (1, '今天明天');
insert into t1 values (2, '话剧的程序员');
insert into t1 values (3, '水仙花');
insert into t1 values (4, '我们');
insert into t1 values (5, '洗衣机');
insert into t1 values (6, '可以的');
insert into t1 values (7, '一蹴而就');
insert into t1 values (8, '你们好');
insert into t1 values (9, '你们好');
insert into t1 values (10, '大家好');

select i1,s1, repeat (s1, 1) from t1 order by 1;

select i1,s1, repeat (s1, 3) from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
