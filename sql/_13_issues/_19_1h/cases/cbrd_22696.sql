drop table if exists t;
CREATE TABLE t (a int, b int, INDEX i_ab (a, b));
insert into t values (1, 1);

--test: cub_server crashed for below
select 'hello', a from t where a=1 group by b order by a,b limit 1;

insert into t values (1, 3);
insert into t values (2, 4);
insert into t values (3, 5);
insert into t values (4, 1);

--test: cub_server crashed for below
select 'hello', a , b from t group by b order by a,b DESC limit 5;

select 'hello', a , b from t group by a order by a,b DESC limit 5;

select sum(b) from t group by b order by a,b DESC limit 5;

drop table if exists t;
