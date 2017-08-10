-- set up
create table t (a double, b double);
insert into t values (1, 9);
insert into t values (6, 1);
insert into t values (2, 3);

create table u (c double, d double);
insert into u values (6, 4);
insert into u values (5, 5);
insert into u values (2, 8);

create table v (e double, f double);
insert into v values (4, 5);
insert into v values (3, 7);
insert into v values (7, 8);

create table w (g double, h double);
insert into w values (1, 3);
insert into w values (2, 4);
insert into w values (3, 1);

-- multiple aggregates
select (select (select sum(a) + avg(c) from v order by e limit 1) from u order by c limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+b) from v order by e limit 1) from u order by c limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+f) from v order by e limit 1) from u order by c limit 1) as x, a from t order by a;

select (select (select sum(a) + avg(c) from v order by e limit 1) from u order by c limit 1) as x, 
       (select (select sum(a+e) + avg(c+b) from v order by e limit 1) from u order by c limit 1) as y,
a from t order by a;

-- group by
select (select (select sum(a) + avg(c) from v group by e order by e limit 1) from u order by c limit 1) as x, a from t order by a;
select (select (select sum(a) + avg(c) from v order by e limit 1) from u group by d order by d limit 1) as x, a from t order by a;
select (select (select sum(a) + avg(c) from v order by e limit 1) from u order by c limit 1) as x, a from t group by b order by b;
select (select (select sum(a) + avg(c) from v group by e order by e limit 1) from u group by c order by c limit 1) as x, a from t group by b order by b;

select (select (select sum(a+e) + avg(c+b) from v group by e order by e limit 1) from u order by c limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+b) from v order by e limit 1) from u group by d order by d limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+b) from v order by e limit 1) from u order by c limit 1) as x, a from t group by b order by b;
select (select (select sum(a+e) + avg(c+b) from v group by e order by e limit 1) from u group by d order by d limit 1) as x, a from t group by b order by b;

select (select (select sum(a+e) + avg(c+f) from v group by e order by e limit 1) from u order by c limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+f) from v order by e limit 1) from u group by d order by d limit 1) as x, a from t order by a;
select (select (select sum(a+e) + avg(c+f) from v order by e limit 1) from u order by c limit 1) as x, a from t group by b order by b;
select (select (select sum(a+e) + avg(c+f) from v group by e order by e limit 1) from u group by d order by d limit 1) as x, a from t group by b order by b;

-- clear
drop table t, u, v, w;
