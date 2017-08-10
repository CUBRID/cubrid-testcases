--TEST: [Analytic Functions] Result of avg(a) over(order by b) is incorrect.


create table tt(a int, b varchar(10));
insert into tt values(1, 'a');
insert into tt values(4, 'a');
insert into tt values(2, 'b');
insert into tt values(3, 'c');

select a, b, avg(a) over() from tt order by a;
select a, b, avg(a) over(order by b) from tt order by a;
select a, b, avg(a) over(partition by b) from tt order by a;
select a, b, avg(a) over(partition by b order by a) from tt order by a;


drop table tt;


