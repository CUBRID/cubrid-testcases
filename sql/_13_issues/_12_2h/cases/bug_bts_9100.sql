--TEST: [Analytic Functions] Result is incorrect when an analytic function is used in an IN expression and there is an order by clause in the subquery.


drop table if exists tt;

create table tt(id int, a int, b varchar(10));
insert into tt values(1, 1, 'a');
insert into tt values(2, 1, 'a');
insert into tt values(3, 1, 'b');
insert into tt values(4, 2, 'b');
insert into tt values(5, 2, 'a');
insert into tt values(6, 2, 'a');
insert into tt values(7, 2, 'b');
insert into tt values(8, 3, 'c');
insert into tt values(9, 3, 'b');
insert into tt values(10, 3, 'c');

--OK
select id, a, b from tt where id in (select row_number() over(partition by b order by a) from tt) order by 1;
--with order by clause in the subquery
select id, a, b from tt where id in (select row_number() over(partition by b order by a) from tt order by b) order by 1;


--OK
select id, a, b from tt where id in (select row_number() over(partition by b) from tt) order by 1;
--with order by clause in the subquery
select id, a, b from tt where id in (select row_number() over(partition by b) from tt order by b) order by 1;


--OK
select id, a, b from tt where id in (select row_number() over(partition by a order by id) from tt) order by 1;
--with order by clause in the subquery
select id, a, b from tt where id in (select row_number() over(partition by a order by id) from tt order by a) order by 1;

drop table tt;
