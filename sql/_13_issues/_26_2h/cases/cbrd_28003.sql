/**
 *  This test case verifies CBRD-28003: a false ON condition of an outer join that reads no table
 *  removed every row when another join stood above the outer join
 *
 *  An ON condition of an outer join that reads no table, such as a bind variable or a constant
 *  expression that the executor computes, belongs to that outer join. The optimizer also applied it
 *  to the topmost plan - the cross join with a table joined by a comma or CROSS JOIN, or a join above
 *  the outer join in a single partition - so a false condition left no row instead of the rows of
 *  the preserved side with NULL inner columns. After the fix the outer join alone evaluates it.
 *
 *  Coverage:
 *    Case 1:  comma join, CROSS JOIN, the comma after the outer join, RIGHT OUTER JOIN and a WHERE term that is no join term keep the preserved rows
 *    Case 2:  a bind variable in the ON condition keeps the preserved rows when false and joins when true
 *    Case 3:  one partition with an inner join above the outer join keeps the preserved rows
 *    Case 4:  the rows, GROUP BY, three partitions and an outer join over the outer join
 *    Case 5:  results that the fix does not change
 */
drop table if exists t_x, t_o, t_i;
create table t_x (a int);
create table t_o (b int);
create table t_i (c int);
insert into t_x values (1), (2);
insert into t_o values (1), (2), (3);
insert into t_i values (1);

evaluate 'Case 1: a false ON condition that reads no table keeps the preserved rows; result = 6, 0 for each';
select count(*), count(t_i.c) from t_x, t_o left outer join t_i on cast(2 as varchar) = '1';
select count(*), count(t_i.c) from t_x cross join t_o left outer join t_i on cast(2 as varchar) = '1';
select count(*), count(t_i.c) from t_o left outer join t_i on cast(2 as varchar) = '1', t_x;
select count(*), count(t_i.c) from t_x, t_i right outer join t_o on cast(2 as varchar) = '1';
select count(*), count(t_i.c) from t_x, t_o left outer join t_i on cast(2 as varchar) = '1' where t_x.a > 0;

evaluate 'Case 2: a bind variable in the ON condition; result = 6, 0 when false and 6, 2 when true';
prepare q_on from 'select count(*), count(t_i.c) from t_x, t_o left outer join t_i on t_i.c = t_o.b and ? = 1';
execute q_on using 2;
execute q_on using 1;
deallocate prepare q_on;

evaluate 'Case 3: one partition with an inner join above the outer join; result = 2, 0 for each and 2, 1 when true';
-- the ORDERED hint joins t_o and t_i first, so the inner join with t_x is the topmost plan
select /*+ ORDERED */ count(*), count(t_i.c) from t_o left outer join t_i on cast(2 as varchar) = '1' inner join t_x on t_x.a = t_o.b;
select /*+ ORDERED */ count(*), count(t_i.c) from t_o left outer join t_i on cast(2 as varchar) = '1', t_x where t_x.a = t_o.b;
-- without the hint the optimizer picks the join order
select count(*), count(t_i.c) from t_x inner join t_o on t_x.a = t_o.b left outer join t_i on cast(2 as varchar) = '1';
select count(*), count(t_i.c) from t_x, t_o left outer join t_i on cast(2 as varchar) = '1' where t_x.a = t_o.b;
prepare q_on2 from 'select /*+ ORDERED */ count(*), count(t_i.c) from t_o left outer join t_i on t_i.c = t_o.b and ? = 1 inner join t_x on t_x.a = t_o.b';
execute q_on2 using 2;
execute q_on2 using 1;
deallocate prepare q_on2;

evaluate 'Case 4: the rows, GROUP BY, three partitions and an outer join over the outer join; result = 6 rows with NULL, 3 groups of 2, 12, then 6, 2, 0';
select t_x.a, t_o.b, t_i.c from t_x, t_o left outer join t_i on cast(2 as varchar) = '1' order by 1, 2;
select t_o.b, count(*) from t_x, t_o left outer join t_i on cast(2 as varchar) = '1' group by t_o.b order by 1;
select count(*) from t_x, t_o left outer join t_i on cast(2 as varchar) = '1', t_x t_y;
select count(*), count(t_i.c), count(t_z.a) from t_x, t_o left outer join t_i on t_i.c = t_o.b left outer join t_x t_z on cast(2 as varchar) = '1';

evaluate 'Case 5: results that the fix does not change; result = 6, 3, 2, 6, 0, 0, 0, 0, 6';
select count(*) from t_x, t_o left outer join t_i on 1 = 0;
select count(*), count(t_i.c) from t_o left outer join t_i on cast(2 as varchar) = '1';
-- the outer join is the topmost plan, so the ON condition stays with it before the fix as well
select /*+ ORDERED */ count(*), count(t_i.c) from t_x inner join t_o on t_x.a = t_o.b left outer join t_i on cast(2 as varchar) = '1';
select count(*), count(t_i.c) from t_x, t_o left outer join t_i on cast(1 as varchar) = '1';
-- a WHERE term that reads no table still filters the whole result
select count(*) from t_x, t_o left outer join t_i on t_i.c = t_o.b where cast(2 as varchar) = '1';
select count(*) from t_x, t_o where not exists (select 1 from t_i where t_i.c = t_o.b) and cast(2 as varchar) = '1';
-- inner and semi joins drop the rows when their condition is false, and an anti join keeps them
select count(*) from t_x, t_o inner join t_i on cast(2 as varchar) = '1';
select count(*) from t_x, t_o where exists (select 1 from t_i where t_i.c = t_o.b and cast(2 as varchar) = '1');
select count(*) from t_x, t_o where not exists (select 1 from t_i where t_i.c = t_o.b and cast(2 as varchar) = '1');

drop table t_x, t_o, t_i;
