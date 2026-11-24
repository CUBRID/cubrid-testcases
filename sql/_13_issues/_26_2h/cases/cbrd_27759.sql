/**
 *  This test case verifies CBRD-27759: non-class right inputs of LEFT JOIN
 *  must compile safely and preserve duplicate and NULL-extended rows.
 *  Before the fix, reading the right column only in ON can crash CAS.
 *  Results match the finite input oracle and NO_ELIMINATE_JOIN twins.
 *  Class-first and collection-first mixed joins preserve both left rows,
 *  including the hinted class-first form that previously lost row 2.
 *  The pre-fix compiler crash proves the risky path.
 *  Traces distinguish real-class elimination from non-class preservation.
 *  Coverage:
 *    Case 1-4: SET column, JSON_TABLE, literal and correlated ON-only equality
 *    Case 5-8: MULTISET and JSON duplicates, empty and SQL NULL inputs
 *    Case 9-12: unique and nonunique classes, UNION ALL and CTE right inputs
 *    Case 13: mixed class and collection joins in both positions
 *    Case 14-17: COUNT, projected and correlated forms of the same joins
 *    Case 18-19: inequality ON and empty, NULL or NULL-element columns
 *    Case 20: class and subquery right inputs with equality and inequality
 */

drop table if exists t_outer, t_unique, t_duplicate, t_edge, t_rhs;
-- Two left rows are sufficient: this compile-time guard has no size threshold.
create table t_outer (id int, st set(int), j json);
insert into t_outer values (1,{1,2},'[1,1,2]'),(2,{3},'[3]');
-- The primary key permits elimination when the right side is read only in ON.
create table t_unique (v int primary key);
insert into t_unique values (1),(2);
-- Duplicate keys make erroneous elimination visible as lost output rows.
create table t_duplicate (v int);
insert into t_duplicate values (1),(1),(2);
-- Empty, SQL NULL, three-element and NULL-element inputs held in columns.
create table t_edge (id int, st set(int), j json);
insert into t_edge values (1,{1,2},'[1,2]'),(2,{3},'[3]'),(3,{},'[]'),(4,NULL,NULL),(5,{1,2,3},'[1,2,3]'),(6,{NULL,1},'[null,1]');
create table t_rhs (v int);
insert into t_rhs values (1),(2),(3);
update statistics on t_outer,t_unique,t_duplicate,t_edge,t_rhs with fullscan;
set trace on;


evaluate 'Case 1: collection column returns left rows 1 and 2';
select /*+ recompile */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=1 order by 1;


evaluate 'Case 2: JSON_TABLE preserves two matches and one unmatched row';
select /*+ recompile */ o.id from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;


evaluate 'Case 3: collection literal returns left rows 1 and 2';
select /*+ recompile */ o.id from t_outer o left outer join table({1,2}) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table({1,2}) s(v) on s.v=1 order by 1;


evaluate 'Case 4: correlated equality preserves unmatched row 2';
select /*+ recompile */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=o.id order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=o.id order by 1;


evaluate 'Case 5: MULTISET equality returns two copies of each left row';
select /*+ recompile */ o.id from t_outer o left outer join table(multiset {1,1,2}) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table(multiset {1,1,2}) s(v) on s.v=1 order by 1;


evaluate 'Case 6: JSON grouped counts are (1,2,2) and (2,1,0)';
select /*+ recompile */ o.id, count(*), count(s.v) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 group by o.id order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, count(*), count(s.v) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 group by o.id order by 1;


evaluate 'Case 7: empty input gives count star 2 and count right 0';
select /*+ recompile */ count(*), count(s.v) from t_outer o left outer join table(cast({} as set(integer))) s(v) on s.v=1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_outer o left outer join table(cast({} as set(integer))) s(v) on s.v=1;


evaluate 'Case 8: SQL NULL input returns left rows 1 and 2';
select /*+ recompile */ o.id from t_outer o left outer join table(cast(NULL as set(integer))) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table(cast(NULL as set(integer))) s(v) on s.v=1 order by 1;


evaluate 'Case 9: real unique class can be eliminated without changing rows';
select /*+ recompile */ o.id from t_outer o left outer join t_unique s on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join t_unique s on s.v=1 order by 1;


evaluate 'Case 10: real nonunique class returns two copies of each left row';
select /*+ recompile */ o.id from t_outer o left outer join t_duplicate s on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join t_duplicate s on s.v=1 order by 1;


evaluate 'Case 11: nonmergeable UNION ALL returns two copies of each left row';
select /*+ recompile */ o.id from t_outer o left outer join (select v from t_unique union all select v from t_unique) s on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join (select v from t_unique union all select v from t_unique) s on s.v=1 order by 1;


evaluate 'Case 12: CTE returns two copies of each left row';
with rhs as (select v from t_unique union all select v from t_unique) select /*+ recompile */ o.id from t_outer o left outer join rhs s on s.v=1 order by 1;
show trace;
with rhs as (select v from t_unique union all select v from t_unique) select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join rhs s on s.v=1 order by 1;


evaluate 'Case 13: mixed entity and nonentity specs preserve both left rows';
select /*+ recompile */ o.id from t_outer o left outer join t_unique u on u.v=1 left outer join table(o.st) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join t_unique u on u.v=1 left outer join table(o.st) s(v) on s.v=1 order by 1;
show trace;
-- The collection-first form is an equivalent reference for these data.
select /*+ recompile */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=1 left outer join t_unique u on u.v=1 order by 1;
show trace;
-- Disable tracing before the last reference query to avoid a leaked plan.
set trace off;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table(o.st) s(v) on s.v=1 left outer join t_unique u on u.v=1 order by 1;


evaluate 'Case 14: COUNT star with the right column read only in ON';
select /*+ recompile */ count(*) from t_outer o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*) from t_outer o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile */ count(*) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile */ count(*) from t_outer o left outer join table({1,2}) s(v) on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*) from t_outer o left outer join table({1,2}) s(v) on s.v=1;


evaluate 'Case 15: COUNT of the right column excludes NULL extension';
select /*+ recompile */ count(s.v) from t_outer o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(s.v) from t_outer o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile */ count(s.v) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(s.v) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;


evaluate 'Case 16: projected right column shows matches and NULL extension';
select /*+ recompile */ o.id, s.v from t_outer o left outer join table(o.st) s(v) on s.v=1 order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_outer o left outer join table(o.st) s(v) on s.v=1 order by 1, 2;
select /*+ recompile */ o.id, s.v from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1, 2;


evaluate 'Case 17: correlated equality in COUNT and literal forms';
select /*+ recompile */ count(*) from t_outer o left outer join table(o.st) s(v) on s.v=o.id;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*) from t_outer o left outer join table(o.st) s(v) on s.v=o.id;
select /*+ recompile */ count(*) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*) from t_outer o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id;
select /*+ recompile */ o.id, s.v from t_outer o left outer join table({1,2}) s(v) on s.v=o.id order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_outer o left outer join table({1,2}) s(v) on s.v=o.id order by 1, 2;


evaluate 'Case 18: inequality ON keeps every match and unmatched row';
select /*+ recompile */ o.id, s.v from t_edge o left outer join table(o.st) s(v) on s.v>0 order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_edge o left outer join table(o.st) s(v) on s.v>0 order by 1, 2;
select /*+ recompile */ o.id, s.v from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v>0 order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v>0 order by 1, 2;
select /*+ recompile */ o.id from t_outer o left outer join table({1,2}) s(v) on s.v>0 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left outer join table({1,2}) s(v) on s.v>0 order by 1;
select /*+ recompile */ count(*), count(s.v) from t_outer o left outer join table({1,2}) s(v) on s.v>0;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_outer o left outer join table({1,2}) s(v) on s.v>0;


evaluate 'Case 19: empty, NULL and NULL-element columns are NULL-extended';
select /*+ recompile */ count(*), count(s.v) from t_edge o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_edge o left outer join table(o.st) s(v) on s.v=1;
select /*+ recompile */ count(*), count(s.v) from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile */ o.id from t_edge o left outer join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_edge o left outer join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile */ o.id from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile */ count(*), count(s.v) from t_edge o left outer join table(o.st) s(v) on s.v=99;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_edge o left outer join table(o.st) s(v) on s.v=99;
select /*+ recompile */ count(*), count(s.v) from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=99;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_edge o left outer join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=99;


evaluate 'Case 20: class and subquery right inputs match the oracle';
select /*+ recompile */ count(*), count(s.v) from t_outer o left outer join t_rhs s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_outer o left outer join t_rhs s on s.v=1;
select /*+ recompile */ o.id, s.v from t_outer o left outer join t_rhs s on s.v>o.id order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_outer o left outer join t_rhs s on s.v>o.id order by 1, 2;
select /*+ recompile */ count(*), count(s.v) from t_outer o left outer join (select v from t_rhs) s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*), count(s.v) from t_outer o left outer join (select v from t_rhs) s on s.v=1;
select /*+ recompile */ o.id, s.v from t_outer o left outer join (select v from t_rhs) s on s.v>o.id order by 1, 2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id, s.v from t_outer o left outer join (select v from t_rhs) s on s.v>o.id order by 1, 2;

drop table t_outer,t_unique,t_duplicate,t_edge,t_rhs;
