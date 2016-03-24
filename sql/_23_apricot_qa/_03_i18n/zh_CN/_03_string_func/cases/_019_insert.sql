--+ holdcas on;
set names utf8;
select insert('今天明天',1,1,'咱');

select insert('今天明天',1,1,'们');

select insert('今天明天',1,1,'他');

select insert('今天明天',2,1,'咱');

select insert('今天明天',2,1,'们');

select insert('今天明天',2,1,'他');

select insert('今天明天',2,5,'咱');

select insert('今天明天',2,5,'们');

select insert('今天明天',2,5,'他');

select insert('今天明天',3,0,'们');

select insert('今天明天',3,-1,'们');

select insert('',1,1,'他');

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_gen);
insert into t1 values (1, '今天明天');
insert into t1 values (2, '我们');
insert into t1 values (3, '水仙花');
insert into t1 values (4, '话剧的程序员');
insert into t1 values (5, '洗衣机');
insert into t1 values (6, '可以的');
insert into t1 values (7, '一蹴而就');
insert into t1 values (8, '你们好');
insert into t1 values (9, '你们好');
insert into t1 values (10, '大家好');


select i1, s1, insert (s1,1,1,'们') from t1 order by 1;

select i1, s1, insert (s1,3,0,'测试_') from t1 order by 1;

select i1, s1, insert (s1,2,2,'高兴阿') from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
