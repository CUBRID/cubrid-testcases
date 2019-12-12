create table t (a string);

insert into t values ('abcdef'),('aBCDe'),('abC'),('AB'),('xyz'),('Xabc');

create index idx on t(lower(a));

select * from t where lower(a) like 'abc%';

drop t;
create table t (a char(10));

insert into t values ('abcdef'),('aBCDe'),('abC'),('AB'),('xyz'),('Xabc');

create index idx on t(lower(a));

select * from t where lower(a) like 'abc%';

drop t;
create table t (a varchar(10));

insert into t values ('abcdef'),('aBCDe'),('abC'),('AB'),('xyz'),('Xabc');

create index idx on t(lower(a));

select * from t where lower(a) like 'abc%';

drop t;
