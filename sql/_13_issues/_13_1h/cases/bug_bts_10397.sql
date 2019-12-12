--TEST: Execute "INSERT INTO t1 SELECT 1,j" and throw system error (ERROR: System error (generate attr) in ../../src/parser/xasl_generation.c (line: 9891))


-- insert spec is referred by attributes in values clause.
drop if exists s,t;

create table t (i int, j int);
create table s (attr t);

insert into t values(1, 100);

-- this shouldn't report an error
insert into t values (j, i);
insert into t values (j, i);
insert into t values (j, i);

select * from t order by 1;

-- report an error
insert into t select 1,j;
-- report an error
insert into t values (1, select j);
-- report an error
insert into t values (1, select count (*) from (select i xi, j xj from t) as x where xi = j);

-- report an error
insert into s values (insert into t values (1, attr.i));

drop s,t;
