-- set up scenario
create table t (a double, b double);
insert into t values (1, 1);

create table u (c double, d double);
insert into u values (2, 2);

create table v (e double, f double);
insert into v values (3, 3);

create table w (g double, h double);
insert into w values (4, 4);

-- SIMPLE SELECT
-- uncorrelated test
select (select (select (select g from w ) from v ) from u ) as x, a from t order by a;

select (select (select (select sum(a) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(c) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(e) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g) from w ) from v ) from u ) as x, a from t order by a;

select (select (select (select sum(g+h) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+e) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+c) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+a) from w ) from v ) from u ) as x, a from t order by a;

select (select (select (select sum(g+h)/d from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+e)/d from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+c)/d from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+a)/d from w ) from v ) from u ) as x, a from t order by a;

select (select (select (select sum(g+h)/avg(d) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+e)/avg(d) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+c)/avg(d) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(g+a)/avg(d) from w ) from v ) from u ) as x, a from t order by a;

select (select (select (select sum(e+f) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(e+c) from w ) from v ) from u ) as x, a from t order by a;
select (select (select (select sum(e+a) from w ) from v ) from u ) as x, a from t order by a;

-- correlated test (v correlated to t)
select (select (select (select g from w ) from v  where e > a) from u ) as x, a from t order by a;

select (select (select (select sum(a) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(c) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(e) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g) from w ) from v where e > a) from u ) as x, a from t order by a;

select (select (select (select sum(g+h) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+e) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+c) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+a) from w ) from v where e > a) from u ) as x, a from t order by a;

select (select (select (select sum(g+h)/d from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+e)/d from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+c)/d from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+a)/d from w ) from v where e > a) from u ) as x, a from t order by a;

select (select (select (select sum(g+h)/avg(d) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+e)/avg(d) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+c)/avg(d) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(g+a)/avg(d) from w ) from v where e > a) from u ) as x, a from t order by a;

select (select (select (select sum(e+f) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(e+c) from w ) from v where e > a) from u ) as x, a from t order by a;
select (select (select (select sum(e+a) from w ) from v where e > a) from u ) as x, a from t order by a;

-- WITH LIMIT CLAUSE
insert into t values (1, 1);
insert into u values (2, 2);
insert into v values (3, 3);
insert into w values (4, 4);

-- uncorrelated
select (select (select (select g from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(a) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(c) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/d from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/d from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/d from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/d from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/avg(d) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/avg(d) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/avg(d) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/avg(d) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(e+f) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+c) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+a) from w limit 1) from v limit 1) from u limit 1) as x, a from t order by a limit 1;

-- correlated
select (select (select (select g from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(a) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(c) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/d from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/d from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/d from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/d from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/avg(d) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/avg(d) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/avg(d) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/avg(d) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(e+f) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+c) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+a) from w limit 1) from v where e > a limit 1) from u limit 1) as x, a from t order by a limit 1;

-- WITH LIMIT + ORDER BY CLAUSE
insert into t values (10, 10);
insert into u values (20, 20);
insert into v values (30, 30);
insert into w values (40, 40);

-- uncorrelated
select (select (select (select g from w order by h limit 1) from v order by f limit 1) from u order by d  limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(a) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(c) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/d from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/d from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/d from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/d from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/avg(d) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/avg(d) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/avg(d) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/avg(d) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(e+f) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+c) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+a) from w order by h limit 1) from v order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

-- correlated
select (select (select (select g from w order by h limit 1) from v order by f limit 1) from u order by d  limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(a) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(c) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/d from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/d from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/d from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/d from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(g+h)/avg(d) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+e)/avg(d) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+c)/avg(d) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(g+a)/avg(d) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

select (select (select (select sum(e+f) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+c) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;
select (select (select (select sum(e+a) from w order by h limit 1) from v where e > a order by f limit 1) from u order by d limit 1) as x, a from t order by a limit 1;

-- cleanup
drop table t, u, v, w;
