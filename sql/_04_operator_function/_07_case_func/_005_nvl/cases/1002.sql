--Test nested nvl
create table t(a int, b char(10));

insert into t values( 1, 'a');

select nvl('abc', null) from t;

select nvl(nvl('abc',null), 'abc') from t;

select nvl2(nvl(null, 'abc'), null, null) from t;

select nvl(nvl2('abc', null, 'abc'), null) from t;

drop class t;