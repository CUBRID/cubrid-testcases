/**
 *  This test case verifies CBRD-28078: a null-safe comparison whose operands are both negated,
 *  such as (- a) <=> (- b), failed with "unknown opcode operator is not defined", and a debug
 *  client aborted in pt_show_binopcode ().
 *
 *  The query rewrite turns "-x op -y" into "x op2 y", op2 being the converse operator of op. The
 *  null-safe equality <=> has no converse in pt_converse_op (), but the case with a minus on both
 *  sides did not check it and wrote operator 0 over the term. The term now keeps its minus signs
 *  and returns the rows of a <=> b. The cases put the term where the rewrite visits it: a WHERE
 *  term, an OR, a join condition, a HAVING that holds aggregates, START WITH, CONNECT BY, the WHERE
 *  of a hierarchical query and of UPDATE and DELETE. A HAVING over the GROUP BY column alone and a
 *  START WITH of one table move to the WHERE before the rewrite, so they go the WHERE way.
 *
 *  Coverage:
 *    Case 1:  (- a) <=> (- a) and (- b) <=> (- b) in WHERE return every row
 *    Case 2:  (- a) <=> (- b) and a double minus return the rows of a <=> b, a host variable bound
 *             to 1 returns the row of a <=> 1, and an OR adds its own row
 *    Case 3:  the term as a join condition of a comma join, JOIN ON and LEFT JOIN ON
 *    Case 4:  the term in a HAVING over aggregates, in START WITH, in CONNECT BY with PRIOR and in
 *             the WHERE of a hierarchical query
 *    Case 5:  the term in the WHERE of DELETE and UPDATE changes the rows of a <=> b
 *    Case 6:  controls that the rewrite handled before keep their results
 */
drop table if exists t_ns;
create table t_ns (id int primary key, a double, b bigint);
insert into t_ns values (1, 1, 1), (2, null, null), (3, 2, 3), (4, 3, 1);

evaluate 'Case 1: (- a) <=> (- a) and (- b) <=> (- b) return every row; result = 1, 2, 3, 4';
select id from t_ns where (- a) <=> (- a) order by id;
select id from t_ns where (- b) <=> (- b) order by id;

evaluate 'Case 2: (- a) <=> (- b) and a double minus return 1, 2 as a <=> b does, a host variable bound to 1 returns 1, the OR adds 3';
select id from t_ns where a <=> b order by id;
select id from t_ns where (- a) <=> (- b) order by id;
select id from t_ns where - (- a) <=> - (- b) order by id;
$int, $1
select id from t_ns where (- a) <=> (- ?) order by id;
select id from t_ns where (- a) <=> (- b) or a = 2 order by id;

evaluate 'Case 3: the term as a join condition matches a <=> b, the outer join keeps x.id 3';
select x.id, y.id from t_ns x, t_ns y where (- x.a) <=> (- y.a) order by 1, 2;
select x.id, y.id from t_ns x join t_ns y on (- x.a) <=> (- y.b) order by 1, 2;
select x.id, y.id from t_ns x left join t_ns y on (- x.a) <=> (- y.b) order by 1, 2;

evaluate 'Case 4: the term in a HAVING over aggregates, START WITH, CONNECT BY PRIOR and the WHERE of a hierarchical query';
select a, count (*) from t_ns group by a having (- min (a)) <=> (- min (b)) order by a;
select id, level from t_ns start with (- a) <=> (- b) connect by nocycle prior id < id and prior id = 1 order by id, level;
select id, level from t_ns start with id = 1 connect by nocycle prior (- a) <=> (- b) and prior id < id order by id, level;
select id, level from t_ns where (- a) <=> (- b) start with id = 1 connect by nocycle prior id < id order by id, level;

evaluate 'Case 5: DELETE and UPDATE with the term change the rows of a <=> b; result = 3, 4 left, then 3, 4, 11, 12';
autocommit off;
delete from t_ns where (- a) <=> (- b);
select id from t_ns order by id;
rollback;
update t_ns set id = id + 10 where (- a) <=> (- b);
select id from t_ns order by id;
rollback;
autocommit on;

evaluate 'Case 6: controls - a <=> (+ a), (- a) = (- a), (- a) > (- b), the select list, (- a) <=> 1 and NOT';
select id from t_ns where a <=> (+ a) order by id;
select id from t_ns where (- a) = (- a) order by id;
select id from t_ns where (- a) > (- b) order by id;
select id, ((- a) <=> (- a)) from t_ns order by id;
select id from t_ns where (- a) <=> 1 order by id;
select id from t_ns where not ((- a) <=> (- b)) order by id;

drop table t_ns;
