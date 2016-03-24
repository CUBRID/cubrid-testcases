create table foo(a int);
insert into foo values(1), (2), (3), (3), (5), (2), (1);


select max(distinctrow a) from foo;
select avg(distinctrow a) from foo;
select count(distinctrow a) from foo;
select min(distinctrow a) from foo;
select stddev(distinctrow a) from foo;
select stddev_pop(distinctrow a) from foo;
select stddev_samp(distinctrow a) from foo;
select sum(distinctrow a) from foo;
select var_pop(distinctrow a) from foo;
select var_samp(distinctrow a) from foo;
select variance(distinctrow a) from foo;


drop table foo;
