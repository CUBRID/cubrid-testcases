--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(20) collate utf8_ja_exp_cbm);

--  match contractions accross boundary: 'ぁゝ' is a constractions in utf8_ja_exp_cbm collation
insert into t values (1,'xxぁゝxx');
insert into t values (2,'xxぁゝ');
insert into t values (3,'xxぁxx');
insert into t values (4,'xxぁ');
insert into t values (11,'xxか');
insert into t values (12,'xxかゝ');
insert into t values (13,'xxかxx');
insert into t values (14,'xxかゝxx');


select * from t where s like '%ぁゝ%' order by 1;
select * from t where s like '%ぁ%' order by 1;

select * from t where s like '%かゝ%' order by 1;
select * from t where s like '%か%' order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
