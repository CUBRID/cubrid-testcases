autocommit off;
drop table if exists foo;
drop view if exists fff;
create class foo( a int );
insert into foo values (1);
insert into foo values (2);
insert into foo values (3);
insert into foo values (4);
select * from foo order by 1;  
create view fff( b foo, c int )
as select x, y.a from foo x, foo y where x.a < y.a;
with recursive cte as (select * from fff) select * from cte order by 1,2;
with recursive cte as (select * from fff) select b.a, c  from cte order by 1,2;             
with recursive cte as (select * from fff) select b.a from cte order by 1;        
with recursive cte as (select * from fff) select c from cte order by 1;            
drop foo;
drop fff;
commit;
autocommit on;
