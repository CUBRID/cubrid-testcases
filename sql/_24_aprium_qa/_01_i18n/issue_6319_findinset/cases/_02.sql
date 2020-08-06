--+ holdcas on;
set names utf8;

drop table if exists t;
create table t (i int, s varchar(10) collate utf8_ja_exp);

-- do not match contractions accross boundary: 'ぁゝ' is a constractions in utf8_ja_exp collation
insert into t values (1,'ぁゝ ,ぁゝ');
insert into t values (2,' ぁゝ,ぁゝ,ぁゝ ');
insert into t values (3,' ぁゝ,ぁゝ,ゝ,ぁ');
insert into t values (4,' ぁゝ,ぁゝ,ゝゝ,');
insert into t values (5,'ぁ ,ぁ');
insert into t values (5,'ゝぁ ,ぁ');

select i, s, find_in_set ('ぁ',s) from t order by 1;
select i, s, find_in_set ('ぁゝ',s) from t order by 1;
select i, s, find_in_set ('ゝ',s) from t order by 1;
select i, s, find_in_set ('ゝゝ',s) from t order by 1;
select i, s, find_in_set ('ゝぁ',s) from t order by 1;


drop table t;
set names iso88591;
commit;
--+ holdcas off;
