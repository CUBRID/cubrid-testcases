--+ holdcas on;
set names utf8;
drop table if exists t;
create table t (i int, s char(10) collate utf8_ja_exp);
create reverse index ri on t(s);

-- do not match contractions accross boundary: 'ぁゝ' is a constractions in utf8_ja_exp collation
insert into t values (1,'xxぁゝxx');
insert into t values (2,'xxぁゝ');
insert into t values (3,'xxぁxx');
insert into t values (4,'xxぁ');

select * from t where s like '%ぁゝ%' order by 1;
select * from t where s like '%ぁ%' order by 1;

drop table t;
set names iso88591;
commit;
--+ holdcas off;
