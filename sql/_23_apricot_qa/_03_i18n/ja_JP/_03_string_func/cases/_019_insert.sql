--+ holdcas on;
set names utf8;
select insert('いイ基盤',1,1,'訊');

select insert('いイ基盤',1,1,'澤');

select insert('いイ基盤',1,1,'図');

select insert('いイ基盤',2,1,'訊');

select insert('いイ基盤',2,1,'澤');

select insert('いイ基盤',2,1,'図');

select insert('いイ基盤',2,5,'訊');

select insert('いイ基盤',2,5,'澤');

select insert('いイ基盤',2,5,'図');

select insert('いイ基盤',3,0,'澤');

select insert('いイ基盤',3,-1,'澤');

select insert('',1,1,'図');

create table t1 (i1 int , s1 VARCHAR(20) collate utf8_ja_exp);
insert into t1 values (1, 'いイ基盤');
insert into t1 values (2, '午前');
insert into t1 values (3, '鳩村薰');
insert into t1 values (4, '繁体的中国語');
insert into t1 values (5, '広東語');
insert into t1 values (6, '暦假报');
insert into t1 values (7, '西暦社会');
insert into t1 values (8, '韓国語');
insert into t1 values (9, '韓国語');
insert into t1 values (10, '渡邊香');


select i1, s1, insert (s1,1,1,'澤') from t1 order by 1;

select i1, s1, insert (s1,3,0,'午後_') from t1 order by 1;

select i1, s1, insert (s1,2,2,'ムモ遠') from t1 order by 1;

drop table t1;
set names iso88591;
commit;
--+ holdcas off;