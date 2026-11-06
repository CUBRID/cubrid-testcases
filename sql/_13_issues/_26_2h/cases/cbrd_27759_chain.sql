/**
 *  This test case verifies CBRD-27759: chained LEFT JOIN preserves all outer rows.
 *  Before the fix, nonadjacent correlated inputs can lose unmatched rows.
 *  Expected rows follow the finite inputs, not hint parity alone.
 *  Projected middle columns and trace scans show retained inputs.
 *  Coverage:
 *    Case 1-4: retained middle with SET or JSON, rows and grouped counts
 *    Case 5-8: duplicate, unmatched and INNER middles, empty and NULL sets
 *    Case 9-11: two or three antecedents including NULL-extended inputs
 *    Case 12-14: INNER derived input, IS NULL filter and ORDERED
 *    Case 15-18: unique, nonunique, INNER and unmatched middles in more forms
 *    Case 19-20: duplicate middle with inequality ON and edge collections
 *    Case 21-23: outer and middle references, collection-first, correlated ON
 *    Case 24: class, subquery and literal right inputs after a middle join
 */

drop table if exists t_outer,t_unique,t_duplicate,t_empty,t_plain,t_edge,t_rhs;
-- Finite relations exercise join semantics without a size threshold.
create table t_outer(id int,st set(int),j json);
insert into t_outer values (1,{1,2},'[1,2]'),(2,{3},'[3]');
-- Primary key permits elimination unless the middle value is read.
create table t_unique(v int primary key);
insert into t_unique values (1),(2);
-- Two physical copies expose accidental duplicate elimination.
create table t_duplicate(v int);
insert into t_duplicate values (1),(1),(2);
-- Empty and NULL collections contain no matching right element.
create table t_empty(id int,st set(int));
insert into t_empty values (3,{}),(4,NULL);
-- Nonunique keys without duplicates, edge collections in columns, and a plain right table.
create table t_plain(v int);
insert into t_plain values (1),(2);
create table t_edge(id int,st set(int),j json);
insert into t_edge values (1,{1,2},'[1,2]'),(2,{3},'[3]'),(3,{},'[]'),(4,NULL,NULL),(5,{1,2,3},'[1,2,3]'),(6,{NULL,1},'[null,1]');
create table t_rhs(v int);
insert into t_rhs values (1),(2),(3);
update statistics on t_outer,t_unique,t_duplicate,t_empty,t_plain,t_edge,t_rhs with fullscan;
set trace on;


evaluate 'Case 1: retained middle and SET preserve NULL extension';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2,3;


evaluate 'Case 2: retained middle and JSON preserve NULL extension';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 3: SET grouped counts distinguish absent right rows';
select /*+ recompile */ o.id,count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 group by o.id order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 group by o.id order by 1;


evaluate 'Case 4: JSON grouped counts distinguish absent right rows';
select /*+ recompile */ o.id,count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 group by o.id order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 group by o.id order by 1;


evaluate 'Case 5: duplicate middle keys preserve actual multiplicity';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_duplicate u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_duplicate u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 6: unmatched middle still preserves both outer rows';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=9 left join table(o.st) s(v) on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=9 left join table(o.st) s(v) on s.v=1 order by 1,2,3;


evaluate 'Case 7: INNER middle keeps LEFT derived input semantics';
select /*+ recompile */ o.id,u.v,s.v from t_outer o inner join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o inner join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 8: empty and NULL collections after middle join';
select /*+ recompile */ o.id,s.v from t_empty o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_empty o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;


evaluate 'Case 9: two antecedents include a NULL extended LEFT input';
select /*+ recompile */ o.id,p.id,s.v from t_outer o left join t_outer p on p.id=9 left join json_table(json_array(o.id,p.id),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,p.id,s.v from t_outer o left join t_outer p on p.id=9 left join json_table(json_array(o.id,p.id),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 10: two antecedents with INNER input retain duplicates';
select /*+ recompile */ o.id,p.id,s.v from t_outer o inner join t_outer p on p.id=o.id left join json_table(json_array(o.id,p.id),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,p.id,s.v from t_outer o inner join t_outer p on p.id=o.id left join json_table(json_array(o.id,p.id),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 11: three antecedents preserve earlier unmatched input';
select /*+ recompile */ o.id,p.id,n.v,s.v from t_outer o left join t_outer p on p.id=9 inner join t_unique n on n.v=2 left join json_table(json_array(o.id,p.id,n.v),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3,4;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,p.id,n.v,s.v from t_outer o left join t_outer p on p.id=9 inner join t_unique n on n.v=2 left join json_table(json_array(o.id,p.id,n.v),'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3,4;


evaluate 'Case 12: INNER derived input does not add unmatched rows';
select /*+ recompile */ o.id from t_outer o left join t_unique u on u.v=1 inner join table(o.st) s(v) on s.v=1 order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left join t_unique u on u.v=1 inner join table(o.st) s(v) on s.v=1 order by 1;


evaluate 'Case 13: IS NULL filter observes the unmatched row';
select /*+ recompile */ o.id from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 where s.v is null order by 1;
show trace;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 where s.v is null order by 1;


evaluate 'Case 14: ORDERED keeps retained JSON middle input';
select /*+ recompile ORDERED */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
show trace;
-- Clear tracing before the last twin so no plan leaks into another case.
set trace off;
select /*+ recompile NO_ELIMINATE_JOIN ORDERED */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 15: unique middle with ON-only, projected and counted right inputs';
select /*+ recompile */ o.id from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2;
select /*+ recompile */ count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1;
select /*+ recompile */ count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;
select /*+ recompile NO_ELIMINATE_JOIN */ count(*),count(s.v) from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1;


evaluate 'Case 16: nonunique middle without duplicates preserves both outer rows';
select /*+ recompile */ o.id from t_outer o left join t_plain u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left join t_plain u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile */ o.id from t_outer o left join t_plain u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o left join t_plain u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;


evaluate 'Case 17: INNER middle with the right input read only in ON';
select /*+ recompile */ o.id from t_outer o inner join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o inner join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1;
select /*+ recompile */ o.id from t_outer o inner join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id from t_outer o inner join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1;


evaluate 'Case 18: unmatched middle and JSON preserve both outer rows';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=9 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=9 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2,3;


evaluate 'Case 19: duplicate middle and inequality ON keep actual multiplicity';
select /*+ recompile */ o.id,u.v,s.v from t_edge o left join t_duplicate u on u.v=1 left join table(o.st) s(v) on s.v>=o.id order by 1,2,3;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_edge o left join t_duplicate u on u.v=1 left join table(o.st) s(v) on s.v>=o.id order by 1,2,3;
select /*+ recompile */ o.id,u.v,s.v from t_edge o left join t_duplicate u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v>=o.id order by 1,2,3;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_edge o left join t_duplicate u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v>=o.id order by 1,2,3;


evaluate 'Case 20: edge collections after a middle join are NULL-extended';
select /*+ recompile */ o.id,s.v from t_edge o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_edge o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=1 order by 1,2;
select /*+ recompile */ o.id,s.v from t_edge o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_edge o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 order by 1,2;


evaluate 'Case 21: ON referencing both outer and middle columns';
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=o.id and s.v=u.v order by 1,2,3;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=o.id and s.v=u.v order by 1,2,3;
select /*+ recompile */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id and s.v=u.v order by 1,2,3;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,u.v,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id and s.v=u.v order by 1,2,3;


evaluate 'Case 22: collection-first joins keep the projected right column';
select /*+ recompile */ o.id,s.v from t_outer o left join table(o.st) s(v) on s.v=1 left join t_unique u on u.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join table(o.st) s(v) on s.v=1 left join t_unique u on u.v=1 order by 1,2;
select /*+ recompile */ o.id,s.v from t_outer o left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 left join t_unique u on u.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=1 left join t_unique u on u.v=1 order by 1,2;


evaluate 'Case 23: correlated equality after a middle join keeps the unmatched row';
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=o.id order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table(o.st) s(v) on s.v=o.id order by 1,2;
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join json_table(o.j,'$[*]' columns(v int path '$')) s on s.v=o.id order by 1,2;


evaluate 'Case 24: class, subquery and literal right inputs after a middle join';
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join t_rhs s on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join t_rhs s on s.v=1 order by 1,2;
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join (select v from t_rhs) s on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join (select v from t_rhs) s on s.v=1 order by 1,2;
select /*+ recompile */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table({1,2}) s(v) on s.v=1 order by 1,2;
select /*+ recompile NO_ELIMINATE_JOIN */ o.id,s.v from t_outer o left join t_unique u on u.v=1 left join table({1,2}) s(v) on s.v=1 order by 1,2;

drop table t_outer,t_unique,t_duplicate,t_empty,t_plain,t_edge,t_rhs;
