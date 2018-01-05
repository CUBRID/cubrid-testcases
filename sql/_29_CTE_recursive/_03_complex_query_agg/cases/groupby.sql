autocommit off;
drop if exists foo,foo1,foo2;
    create class foo(a1 int);
      create class foo1(b1 foo);
      create class foo2(c1 foo1);
insert into foo values(1),(2),(3);
insert into foo1 select foo from foo;
insert into foo2 select foo1 from foo1;
with recursive cte as (select c1.b1.a1
      from foo2
      group by c1.b1.a1) select * from cte order by 1 ;

with recursive cte as (
     select c1.b1.a1 from foo2 group by c1.b1.a1
     union all
     select c1.b1.a1+1 from foo2 group by c1.b1.a1 having  c1.b1.a1<10
) select * from cte order by 1 ;

with recursive cte as (
     select c1.b1.a1 as f1 from foo2 group by c1.b1.a1
     union all
     select f1+1 from cte group by f1 having  f1 <10
) select * from cte order by 1 ;

alter table foo add column a2 timestamptz;
insert into foo values(4,TIMESTAMPTZ'2008-12-31 23:00:00 UTC');
insert into foo values(1,TIMESTAMPTZ'2008-12-31 23:00:00 UTC');
with recursive cte(f1,f2) as (
     select * from foo group by a1
     union all
     select f1+1,f2+1 from cte group by f1 having  f1 <10 order by 1,2
) select * from cte order by 1,2 ;


with recursive cte(f1,f2) as (
     select * from foo group by a1
     union all
     select f1+1,add_months(f2,1) from cte group by f1 having  f1 <10 order by 1,2
) select * from cte order by 1,2 ;

drop foo, foo1, foo2;
rollback;
autocommit on;
