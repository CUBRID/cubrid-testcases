--TEST: [I18N] Incompatible collation will be set to a string constant in some scenarios.

drop table if exists t1;

--CASE 1, function index
set names utf8;

create table t1(a varchar);
create index i on t1(lpad(a, 10, 'X'));

show index in t1;

drop table t1;


--CASE 2, query plan
set names euckr;
create table t1(a varchar);
--@queryplan
select /*+ recompile */ * from t1 where cast(a as char(10)) = 'a';

drop table t1;

--CASE 3, view
set names iso88591;
create table t1(a varchar);
create view v as select * from t1 where a = _euckr'a';

show create view v;

drop view v;
drop table t1;


set names iso88591;
