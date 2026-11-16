/**
 *  This test case verifies CBRD-27503: a session variable assignment in an analytic function argument
 *  crashed the client (csql, CAS) during prepare when the query had an ORDER BY.
 *
 *  The order-dependent rewrite moved the whole analytic function to an outer SELECT and left the derived
 *  table with only its analytic flag. The fix keeps analytic functions out of the rewrite. Each case runs
 *  a query from a derived table sorted outside, where no rewrite runs, and with the query ORDER BY. The two
 *  forms must return the same rows, and a SELECT of the variable shows the last value assigned.
 *
 *  Coverage:
 *    Case 1:  the queries of the issue - MEDIAN, SUM DISTINCT, and AVG with an assignment argument
 *    Case 2:  a value that MEDIAN cannot coerce raises the same error in both forms
 *    Case 3:  next to ROW_NUMBER, the ORDER BY DESC is kept and LAG sees the running count
 *    Case 4:  the argument is evaluated in the input order, before the window sort, in both forms
 *    Case 5:  an assignment beside an analytic function moves out alone and runs after the ORDER BY
 *    Case 6:  an assignment argument of LEAD and of FIRST_VALUE
 *    Case 7:  an assignment in the WITHIN GROUP ORDER BY key of PERCENTILE_CONT
 */

drop table if exists tm;
create table tm (i int, p int, s varchar(30));
insert into tm values (1,1,'1.5'),(2,1,'2.5'),(3,1,'3.5'),(4,2,'4.5'),(5,2,'5.5');
drop table if exists c4e;
create table c4e (x int, s varchar(10));
insert into c4e values (1, '10'), (2, '20'), (3, '10'), (4, null);

evaluate 'Case 1: the queries of the issue return the same rows in both forms';
set @u = 0;
select * from (select i, median(@u := s) over () m from tm) d order by i;
select @u;
set @u = 0;
select i, median(@u := s) over () m from tm order by i;
select @u;
set @w = 'x';
select * from (select x, sum(distinct (@w := s)) over () a, avg((@w := s)) over () b from c4e) d order by x;
select @w;
set @w = 'x';
select x, sum(distinct (@w := s)) over () a, avg((@w := s)) over () b from c4e order by x;
select @w;

evaluate 'Case 2: a value that MEDIAN cannot coerce raises the same error in both forms';
-- '01:00:00' is the value of the issue
insert into tm values (6,2,'01:00:00');
select * from (select i, median(@u := s) over () m from tm) d order by i;
select i, median(@u := s) over () m from tm order by i;
delete from tm where i = 6;

evaluate 'Case 3: next to ROW_NUMBER, the query ORDER BY DESC is kept and LAG sees the running count';
set @u = 0;
select * from (select i, row_number() over (order by i) rn, lag(@u := @u + 1) over (order by i) l from tm) d order by i desc;
select @u;
set @u = 0;
select i, row_number() over (order by i) rn, lag(@u := @u + 1) over (order by i) l from tm order by i desc;
select @u;

evaluate 'Case 4: the argument is evaluated in the input order before the window sort in both forms';
set @u = 0;
select * from (select i, lag(@u := @u + 1) over (order by i desc) l from tm) d order by i;
select @u;
set @u = 0;
select i, lag(@u := @u + 1) over (order by i desc) l from tm order by i;
select @u;

evaluate 'Case 5: an assignment beside an analytic function moves to the outer SELECT and runs after the ORDER BY';
-- Unlike the other cases, only the final @u differs: only the ORDER BY form moves the assignment out
set @u = 0;
select * from (select i, sum(i) over () + (@u := i) m from tm) d order by i desc;
select @u;
set @u = 0;
select i, sum(i) over () + (@u := i) m from tm order by i desc;
select @u;

evaluate 'Case 6: an assignment argument of LEAD and of FIRST_VALUE';
set @u = 0;
select * from (select i, lead(@u := @u + 1) over (order by i) l from tm) d order by i desc;
select @u;
set @u = 0;
select i, lead(@u := @u + 1) over (order by i) l from tm order by i desc;
select @u;
set @w = 'x';
select * from (select i, first_value(@w := s) over (partition by p order by i) f, first_value(@w := s) over (partition by p order by i desc) l from tm) d order by i desc;
select @w;
set @w = 'x';
select i, first_value(@w := s) over (partition by p order by i) f, first_value(@w := s) over (partition by p order by i desc) l from tm order by i desc;
select @w;

evaluate 'Case 7: an assignment in the WITHIN GROUP ORDER BY key of PERCENTILE_CONT';
set @u = 0;
select * from (select i, percentile_cont(0.5) within group (order by (@u := i)) over (partition by p) pc from tm) d order by i desc;
select @u;
set @u = 0;
select i, percentile_cont(0.5) within group (order by (@u := i)) over (partition by p) pc from tm order by i desc;
select @u;

drop variable @u, @w;
drop table tm, c4e;
