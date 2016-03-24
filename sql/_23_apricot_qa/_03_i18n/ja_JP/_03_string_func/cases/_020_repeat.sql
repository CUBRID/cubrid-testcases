--+ holdcas on;
set names utf8;
select repeat('いイ基盤',1);

select repeat('ぃ詳',2);

select repeat('ぃu',3);

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_ja_exp);
insert into t1 values (1, 'いイ基盤');
insert into t1 values (2, '繁体的中国語');
insert into t1 values (3, '鳩村薰');
insert into t1 values (4, '午前');
insert into t1 values (5, '広東語');
insert into t1 values (6, '暦假报');
insert into t1 values (7, '西暦社会');
insert into t1 values (8, '韓国語');
insert into t1 values (9, '韓国語');
insert into t1 values (10, '渡邊香');

select i1,s1, repeat (s1, 1) from t1 order by 1;

select i1,s1, repeat (s1, 3) from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;