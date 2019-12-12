set names utf8;
create table t(s string collate utf8_en_ci);
insert into t values ('aBc');
insert into t values ('aBa');
insert into t values ('ABa');
select * from t where s > _utf8'ab' order by 1;
drop table t;
set names iso88591;
