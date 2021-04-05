--+ holdcas on;

-- create and populate tables
create table t (i int, j int);
create table u (i int, j int);
create table v (i int, j int);

insert into t values (1, 1), (2, 2), (3, 3);
insert into u values (1, 1), (2, 2), (4, 4);
insert into v values (1, 1), (3, 3), (5, 5);

-- case #0 - no specs in view
create view a as select 1 as i;
select * from t, a order by t.i asc;
drop a;

-- case #1 - view with right join
create view a as select u.i as i, u.j as j, v.i as vi, v.j as vj from u right join v on u.i = v.i;
select * from t inner join a on t.i = a.i order by a.vi;
drop a;

-- case #2 - view with cross join
create view a as select u.i as i, u.j as j, v.i as vi, v.j as vj from u, v;
select * from t left join a on t.i = a.i order by t.i, a.i, a.vi;
drop a;

-- cleanup
drop table t, u, v;
commit;

commit;
--+ holdcas off;
