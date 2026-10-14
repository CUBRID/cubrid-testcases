--test: CBRD-27503 a session-variable assignment inside an analytic function argument crashed the
--test: client during prepare when the query also had an ORDER BY: the order-dependent rewrite moved
--test: the whole analytic function into the outer SELECT. Every query here must return or raise an
--test: error -- never crash -- and the ORDER BY forms must return the same rows as the plain forms.
--+ holdcas on;

drop table if exists tm;
create table tm (i int, p int, s varchar(30));
insert into tm values (1,1,'1.5'),(2,1,'2.5'),(3,1,'3.5'),(4,2,'4.5'),(5,2,'5.5');
drop table if exists c4e;
create table c4e (x int, s varchar(10));
insert into c4e values (1, '10'), (2, '20'), (3, '10'), (4, null);

--test: [1] the JIRA queries, without and with the query ORDER BY (the ORDER BY form crashed)
select i, median(@u := s) over () m from tm;
select i, median(@u := s) over () m from tm order by i;
select @u;
select x, sum(distinct (@w := s)) over () a, avg((@w := s)) over () b from c4e;
select x, sum(distinct (@w := s)) over () a, avg((@w := s)) over () b from c4e order by x;
select @w;

--test: [1b] the JIRA's own data: a value the function cannot coerce raises the same error in both
--test: forms instead of crashing
insert into tm values (6,2,'01:00:00');
select i, median(@u := s) over () m from tm;
select i, median(@u := s) over () m from tm order by i;
delete from tm where i = 6;

--test: [2] mixed with other analytic functions: the query ORDER BY (desc) is honored and the
--test: assignment runs in the window order, so lag () sees the running count 1..4
set @u = 0;
select i, row_number() over (order by i) rn, lag(@u := @u + 1) over (order by i) l from tm order by i desc;
select @u;

--test: [3] the assignment beside the analytic function, not inside it: only the assignment is
--test: lifted to the outer SELECT, as before -- it is evaluated after the ORDER BY, so @u ends at 1
set @u = 0;
select i, sum(i) over () + (@u := i) m from tm order by i desc;
select @u;

drop table tm, c4e;
