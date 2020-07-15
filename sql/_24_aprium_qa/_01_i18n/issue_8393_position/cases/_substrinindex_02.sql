--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s varchar(10) collate utf8_ja_exp);

-- do not match contractions accross boundary: 'ぁゝ' is a constractions in utf8_ja_exp collation
insert into t values (1,'ぁゝ _ぁゝ');
insert into t values (2,' ぁゝ_ぁゝ_ぁゝ ');
insert into t values (3,' ぁゝ_ぁゝ_ゝ_ぁ');
insert into t values (4,' ぁゝ_ぁゝ_ゝゝ_');
insert into t values (5,'ぁ _ぁ');
insert into t values (5,'ゝぁ _ぁ');

select i, s, substring_index (s,'ぁ',1) from t order by 1;
select i, s, substring_index (s,'ぁ',-1) from t order by 1;
select i, s, substring_index (s,'ぁゝ',1) from t order by 1;
select i, s, substring_index (s,'ぁゝ',2) from t order by 1;
select i, s, substring_index (s,'ゝ',1) from t order by 1;
select i, s, substring_index (s,'ゝ',2) from t order by 1;
select i, s, substring_index (s,'ゝゝ',1) from t order by 1;
select i, s, substring_index (s,'ゝゝ',2) from t order by 1;
select i, s, substring_index (s,'ゝぁ',1) from t order by 1;
select i, s, substring_index (s,'ゝぁ',-1) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
