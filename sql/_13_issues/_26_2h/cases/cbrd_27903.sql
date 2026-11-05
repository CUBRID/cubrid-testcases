/**
 *  CBRD-27903: a select list column that is the same expression as a GROUP BY key reads the key value
 *  even when a column listed after it holds a pseudocolumn
 *
 *  A select list column that is the same expression as a GROUP BY key reads the key value of its group
 *  instead of being computed again, unless the column holds LEVEL, CONNECT_BY_ISLEAF or
 *  CONNECT_BY_ISCYCLE. The check for a pseudocolumn also looked at the columns listed after the column,
 *  so a later max (level) made the key column be computed again from a row of the group, and the total
 *  row of WITH ROLLUP showed a value instead of null. Now the check looks at the column alone.
 *
 *  t1 (c1, c2) = (1, null), (2, 1), (3, 1), (4, 2)   c2 is the c1 of the parent row
 *
 *  Coverage:
 *  1    the key column c1 % 2 is followed by max (level), the total row of WITH ROLLUP has null as the key
 *  2    the key column is level itself, still left out of the key value and shows the level of each group
 */

drop table if exists t1;
create table t1 (c1 int, c2 int);
insert into t1 values (1, null), (2, 1), (3, 1), (4, 2);


evaluate 'Case 1: the GROUP BY key c1 % 2 is followed by max (level); the total row of WITH ROLLUP has null as the key';
select /*+ recompile */ c1 % 2 as g, count (*) as cnt, max (level) as max_lv from t1
 start with c2 is null connect by prior c1 = c2 group by g with rollup;


evaluate 'Case 2: the GROUP BY key is level itself; each group shows its level';
select /*+ recompile no_hash_aggregate */ level as lv, count (*) as cnt from t1
 start with c2 is null connect by prior c1 = c2 group by lv order by 1;

drop table t1;
