--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_gen, a int, b VARCHAR(20) collate utf8_gen);
insert into t1 values (1, '可不可以',1,'可不 可');
insert into t1 values (2, '美丽的水仙花',1,'学科');
insert into t1 values (3, '绿串株',2,'一蹴而');
insert into t1 values (4, '科学',2,'家大');
insert into t1 values (5, '程序员',2,'可不 可');
insert into t1 values (6, '大家好',2,'家大');
insert into t1 values (7, '一蹴而就',3,'一蹴而');
insert into t1 values (8, '你们好',3,'一蹴而');
insert into t1 values (9, '你们好',3,'家大');
insert into t1 values (10, '测试员',3,'可不 可');

select group_concat (s1 order by 1) from t1 group by a;

select group_concat (s1 order by 1) from t1 group by b;

select group_concat (s1 order by 1 separator '_不_') from t1 group by a;

select group_concat (s1 order by 1 separator '_不_') from t1 group by b;

select group_concat (s1 order by 1 separator '____不不不不不____') from t1 group by b;

set system parameters 'group_concat_max_len=65';

select group_concat (s1 order by 1 separator '____不不不不不____') from t1 group by b;

set system parameters 'group_concat_max_len=64';

select group_concat (s1 order by 1 separator '____不不不不不____') from t1 group by b;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;
