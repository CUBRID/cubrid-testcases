/**
 *  CBRD-27602: a column of a SEMI / ANTI JOIN inner table referenced inside a derived table
 *  of the FROM clause must be rejected.
 *
 *  CTP prints only the error code, and every semantic error is -494, so queries that run with
 *  an outer column in place of the inner column show that the inner reference is what gets
 *  rejected. They use SEMI JOIN: an ANTI JOIN followed by a derived table that refers to the
 *  outer table currently loses the rows that pass the ANTI JOIN.
 */

drop table if exists t1, t2;

create table t1 (c1 int, c2 int);
create table t2 (c1 int primary key, c2 int);

insert into t1 values (1, 10), (2, 20), (3, 30);
insert into t2 values (1, 10), (3, 30), (4, 40);


evaluate 'Case 1: the reported query, ANTI and SEMI JOIN, derived table after a comma';
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o anti join t2 a on a.c1 = o.c1, (select count(*) as cnt from t2 x where x.c2 <= a.c2) d;
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1, (select count(*) as cnt from t2 x where x.c2 <= a.c2) d;


evaluate 'Case 2: inner column in a scalar subquery nested in the derived table';
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1, (select count(*) as cnt from t2 x where x.c2 <= (select max(y.c2) from t2 y where y.c1 = a.c1)) d;
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1, (select count(*) as cnt from t2 x where x.c2 <= (select max(y.c2) from t2 y where y.c1 = o.c1)) d order by 1;


evaluate 'Case 3: derived table joined by INNER JOIN ... ON, of which only the ON was checked before';
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1 inner join (select count(*) as cnt from t2 x where x.c2 <= a.c2) d on d.cnt > 0;
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1 inner join (select count(*) as cnt from t2 x where x.c2 <= o.c2) d on d.cnt > 0 order by 1;


evaluate 'Case 4: a table declared in the derived table under the alias of the inner table is allowed';
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o anti join t2 a on a.c1 = o.c1, (select count(*) as cnt from t2 a where a.c2 >= 30) d order by 1;


evaluate 'Case 5: an inner column in the ON condition of its own join is allowed';
select /*+ recompile ordered use_nl */ o.c1, d.cnt from t1 o semi join t2 a on a.c1 = o.c1 and a.c2 > 10, (select count(*) as cnt from t2 x where x.c2 <= o.c2) d order by 1;


evaluate 'Case 6: the SEMI JOIN inner is itself a derived table, which is allowed';
select /*+ recompile ordered use_nl */ o.c1 from t1 o semi join (select c1, c2 from t2 where c2 >= 30) a on a.c1 = o.c1 order by 1;


drop table t1, t2;
