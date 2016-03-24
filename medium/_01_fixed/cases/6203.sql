autocommit off;
create class city (name string, pop integer);
create class state (name string, cities set of city);
insert into state (name, cities)
    values ('ohio',{
                   insert into city (name, pop) values ('cinn', 1000),
                   insert into city (name, pop) values ('columbus', 1100)}
	   )
    to :st_ohio ;
insert into state (name, cities)
    values ('new hampshire', {
                   insert into city (name, pop) values ('manchester', 300),
                   insert into city (name, pop) values ('merrimack', 22)}
	   )
    to :st_nh;
create class city_rank (description string, min_pop integer, max_pop integer);
insert into city_rank (description, min_pop, max_pop) values ('town', 1, 100);
insert into city_rank (description, min_pop, max_pop) values ('city', 100, 1000);
insert into city_rank (description, min_pop, max_pop) values ('metro', 1000, 10000);
select st.name, ci.name, (select cr.description from city_rank cr
                          where ci.pop >= cr.min_pop and
                                ci.pop < cr.max_pop)
    from state st, TABLE (st.cities) as T(ci) order by 1,2,3;
create class R (r string);
create class S (s string);
create class A (ar R, sas set of S, a string);
insert into R values ('r1') to :r1;
insert into R values ('r2') to :r2;
insert into S values ('s1') to :s1;
insert into S values ('s2') to :s2;
insert into A values (:r1, {:s1,:s2}, 'a1');
select A.a, ts.s, (select A.ar.r + ' ' + ts.s from class db_user)
from A, table(A.sas) as T(ts) order by 1,2,3;
create class foo (bar char(10), baz string);
insert into foo values ('c8', 's8');
insert into foo values ('c4', 's4');
insert into foo values ('c9', 's9');
select bar,
       (select min(f2.bar) from foo f2 where f2.bar = f1.bar),
       (select min(f2.baz) from foo f2 where f2.baz = f1.baz)
from foo f1 order by 1,2,3;
rollback;
