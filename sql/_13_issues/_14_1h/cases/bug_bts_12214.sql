--[i18n] Queries containing named variables are cached without charset or collate modifiers


set names euckr;
select 'a' into :v1;
select collation(:v1);

set names utf8;
select 'a' into :v2;
select collation(:v2);
select charset(:v2);

select 'a' into :v1;
select :v1, collation(:v1);

set names euckr;
select _utf8'a' into :v1;
select :v1, charset(:v1), collation(:v1);

set names utf8;
select _euckr'a' into :v2;
select :v2, charset(:v2), collation(:v2);

set names euckr;
select 'a' collate utf8_en_ci into :v1;
select :v1, charset(:v1), collation(:v1);

set names utf8;
select 'a' collate euckr_bin into :v2;
select :v2, charset(:v2), collation(:v2);


create table t as select :v1, :v2;
desc t;
select collation(`:v1`), collation(`:v2`) from t order by 1;

create view v(a, b) as select :v1, :v2;
desc v;
select collation(a), collation(b) from v order by 1;


drop variable v1, v2;

desc t;
desc v;

drop table t;
drop view v;

set names iso88591;

