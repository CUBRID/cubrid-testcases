autocommit off;
create class x (n int, d double)
	method class set_cost(string, string) function qo_set_cost;
insert into x values (1, 4.2);
insert into x values (2, 42.0);
call set_cost('m-join', '0') on class x;
--set optimization: level 257;
select c.n
  from (select n,d from x) as a(n,d),
       (select n,d from x) as b(n,d),
       (select n,d from x where n = a.n) as c(n,d)
 where a.n = b.n;
select c.n
  from (select n,d from x) as a(n,d),
       (select n,d from x) as b(n,d),
       (select n,d from x where n = a.n
        union all
        select n,d from x where n = b.n) as c(n,c)
 where a.n = b.n;
select a.n + b.n
  from (select n,d from x) as a(n,d),
       (select n,d from x) as b(n,d);
rollback;
