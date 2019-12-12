create table t(a bit(1000));

insert into t values(B'1111111111');

insert into t values(null);

create index idx on t (LEAST(a,a));

drop t;

create table t(a char(3));

insert into t value('SQL');

CREATE INDEX idx ON t(lower (a));

drop table t;


