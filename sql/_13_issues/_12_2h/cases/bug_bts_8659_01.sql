--bts 8659

create table t (a enum('A','B') default 'A');
insert into t values (default);
select default(a) from t;
drop t;

create table t (a enum('A','B') default 'A', b enum('A','C','D') default 'C');
insert into t values default;
insert into t values (default(a), default(a));
insert into t(a) values (default(a));
insert into t(b) values (default(a));
select * from t order by 1,2;
select default(a), default(b) from t;
drop t;

create table t (a int default 0);
create table s (a int default 1);
insert into t values default;
insert into s values default;
select default(a) from t,s;
select default(t.a) from t,s;
select default(t.a), default(s.a) from t,s;
drop t,s;