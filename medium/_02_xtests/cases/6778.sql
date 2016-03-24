autocommit off;
create class foo (a int);
insert into foo values(1);
insert into foo values(1);
insert into foo values(2);
select count(a), (select count(a) from foo where a = t.a)
from foo t
group by a;
select count(a), (select count(a) from foo where a = t.a - 1)
from foo t 
where a = 2
group by a;
select a, count(a)
from foo t
group by a
having a = (select count(a) from foo where a = t.a -1)
rollback;
