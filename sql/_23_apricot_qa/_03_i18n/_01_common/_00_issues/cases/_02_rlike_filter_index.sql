create table t (s varchar, r varchar);
insert into t values ('abc', '^(a|b|c)+$'), ('dab', '^(a|b|c)+$'), ('xxx', '^x{3,5}$');

create index idx on t (s, r) where (s rlike r);
select s from t where s > 'a' using index idx(+);

alter index idx on t rebuild;
select s from t where s > 'a' using index idx(+);

alter index idx on t (s, r) where (now() rlike (left(r, length(r) - 1))) = 0 rebuild;

drop table t;

