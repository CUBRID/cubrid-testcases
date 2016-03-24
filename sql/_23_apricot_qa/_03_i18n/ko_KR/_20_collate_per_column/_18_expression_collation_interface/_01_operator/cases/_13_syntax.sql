--+ holdcas on;
set names utf8;
create table t1 (s1 string charset utf8 collate 'utf8_ko_cs_uca');
insert into t1 values ('가'),( '伽');
create table t2 (s1 string charset utf8 collate 'utf8_bin');
insert into t2 values ('가'),( '伽');
select t1.s1,t2.s1 from t1,t2 where t1.s1<t2.s1 order by 1, 2;
select t1.s1,t2.s1 from t1,t2 where t2.s1<t1.s1 order by 1, 2;
drop t1,t2;
set names iso88591;
commit;
--+ holdcas off;

