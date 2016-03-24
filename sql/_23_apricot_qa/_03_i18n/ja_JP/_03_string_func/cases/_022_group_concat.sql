--+ holdcas on;
set names utf8;
create table t1 (i1 int , s1 VARCHAR(20) collate utf8_ja_exp, a int, b VARCHAR(20) collate utf8_ja_exp);
insert into t1 values (1, 'いイ基盤',1,'いイ 繭');
insert into t1 values (2, '繁体的中国語',1,'学科');
insert into t1 values (3, '鳩村薰',2,'西暦社');
insert into t1 values (4, '午前',2,'假暦');
insert into t1 values (5, '広東語',2,'いイ 繭');
insert into t1 values (6, '暦假报',2,'假暦');
insert into t1 values (7, '西暦社会',3,'西暦社');
insert into t1 values (8, '韓国語',3,'西暦社');
insert into t1 values (9, '韓国語',3,'假暦');
insert into t1 values (10, '渡邊香',3,'いイ 繭');

select group_concat (s1 order by 1) from t1 group by a;

select group_concat (s1 order by 1) from t1 group by b;

select group_concat (s1 order by 1 separator '_實_') from t1 group by a;

select group_concat (s1 order by 1 separator '_實_') from t1 group by b;

select group_concat (s1 order by 1 separator '____實實實實實____') from t1 group by b;

set system parameters 'group_concat_max_len=65';

select group_concat (s1 order by 1 separator '____實實實實實____') from t1 group by b;

set system parameters 'group_concat_max_len=64';

select group_concat (s1 order by 1 separator '____實實實實實____') from t1 group by b;

set system parameters 'group_concat_max_len=1024';

drop table t1;
set names iso88591;
commit;
--+ holdcas off;