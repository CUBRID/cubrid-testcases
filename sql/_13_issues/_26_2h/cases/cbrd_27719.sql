/**
 *  This test case verifies CBRD-27719: an IN, ANY or ALL subquery with ORDER BY and LIMIT is
 *  compared on the wrong set of values because DISTINCT is applied before the row cut
 *
 *  A range predicate (IN, NOT IN, op ANY or SOME, op ALL) compares against the set of
 *  values its subquery returns when run alone.
 *  The subquery used to be made DISTINCT unconditionally, which changed that set when rows
 *  are counted after DISTINCT. The cases print the outer rows that the predicate keeps,
 *  and Case 10 prints the plans.
 *  An uncorrelated IN rewritten into a join must still return each outer row once when
 *  the subquery has duplicates. Subqueries without such a row count keep the previous results.
 *
 *  Coverage:
 *    Case 1:  ORDER BY ... LIMIT, LIMIT m, n and FOR ORDERBY_NUM () keep the first n rows of the subquery, not its first n distinct values
 *    Case 2:  ORDERBY_NUM () in the select list numbers the rows before duplicates are removed
 *    Case 3:  a set operation with LIMIT cuts the UNION ALL and INTERSECT ALL rows, and EXCEPT ALL keeps duplicate values
 *    Case 4:  UPDATE and DELETE pick the same rows as the subquery run alone
 *    Case 5:  control: a subquery without a row count after DISTINCT keeps the previous results
 *    Case 6:  control: forms that the change does not reach keep the previous results
 *    Case 7:  inequality ANY over a row cut compares with the MIN or MAX of the cut rows
 *    Case 8:  ORDER SIBLINGS BY with LIMIT cuts rows before duplicates are removed
 *    Case 9:  the join keeps duplicate outer rows, and EXCEPT ALL keeps duplicate values
 *    Case 10: the plans keep the join: a cut UNION ALL subquery is wrapped in a DISTINCT derived table, a plain IN stays a semi join
 *    Case 11: the row cut also holds in OR, an expression, HAVING, the select list, a nested IN, a CTE, INSERT SELECT, MERGE and PREPARE with a bound LIMIT
 */

drop table if exists t_27719_loc, t_27719_tgt, t_27719_ln, t_27719_tn;

create table t_27719_loc (id int, v int);
create table t_27719_tgt (id int, flag int default 0);
create table t_27719_ln (v int);
create table t_27719_tn (id int);

-- id 1 appears twice: the first two rows by id are {1}, the first two distinct values are {1, 2}
-- a LIMIT or ROWNUM with no ORDER BY reads the rows of these new tables in the order they are inserted
insert into t_27719_loc values (1, 10), (1, 20), (2, 30), (3, 40);
insert into t_27719_tgt (id) values (1), (2), (3), (4);
-- NULL right after the cut: the first three rows are 1, 1, 5 and hold no NULL
insert into t_27719_ln values (1), (1), (null), (5);
insert into t_27719_tn values (1), (2), (3), (4), (5);

evaluate 'Case 1: a row cut after ORDER BY keeps the first n rows of the subquery, not its first n distinct values';
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id not in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id = any (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id > all (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id = all (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id for orderby_num () <= 2) order by 1;
-- the sort key is not in the select list
select id from t_27719_tgt where id in (select id from t_27719_loc order by v limit 2) order by 1;
-- tuple form: control, a build without the fix prints the same rows
select id from t_27719_tgt where (id, id) in (select id, id from t_27719_loc order by id limit 2) order by 1;
-- correlated form
select t.id from t_27719_tgt t where t.id in (select l.id from t_27719_loc l where l.id <= t.id order by l.id limit 2) order by 1;
-- NULL at the cut
select id from t_27719_tn where id not in (select v from t_27719_ln order by v nulls last limit 3) order by 1;

evaluate 'Case 2: ORDERBY_NUM () in the select list numbers the rows before duplicates are removed';
select id from t_27719_tgt where id in (select orderby_num () from t_27719_loc order by id) order by 1;

evaluate 'Case 3: a set operation with LIMIT cuts the UNION ALL and INTERSECT ALL rows, and EXCEPT ALL keeps duplicate values';
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc order by 1 limit 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc limit 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc intersect all select id from t_27719_loc limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc except all select id from t_27719_tgt) order by 1;

evaluate 'Case 4: UPDATE and DELETE pick the same rows as the subquery run alone';
update t_27719_tgt set flag = 1 where id in (select id from t_27719_loc order by id limit 2);
select id from t_27719_tgt where flag = 1 order by 1;
delete from t_27719_tgt where id not in (select id from t_27719_loc order by id limit 2);
select id from t_27719_tgt order by 1;
delete from t_27719_tgt;
insert into t_27719_tgt (id) values (1), (2), (3), (4);

evaluate 'Case 5: control, a subquery without a row count after DISTINCT keeps the previous results';
select id from t_27719_tgt where id in (select id from t_27719_loc limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id) order by 1;
select id from t_27719_tgt where id in (select distinct id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc union select id from t_27719_loc limit 2) order by 1;

evaluate 'Case 6: control, forms that the change does not reach keep the previous results';
-- ROWNUM without ORDER BY cuts rows before DISTINCT
select id from t_27719_tgt where id in (select id from t_27719_loc where rownum <= 2) order by 1;
-- the row cut wrapped in a derived table by hand
select id from t_27719_tgt where id in (select id from (select id from t_27719_loc order by id limit 2) x) order by 1;
-- a scalar comparison and EXISTS are not range predicates
select id from t_27719_tgt where id = (select id from t_27719_loc order by id limit 1) order by 1;
select id from t_27719_tgt where exists (select 1 from (select id from t_27719_loc order by id limit 2) x where x.id = t_27719_tgt.id) order by 1;

evaluate 'Case 7: inequality ANY over a row cut compares with the MIN or MAX of the cut rows';
-- the derived table + MIN/MAX branch of the rewrite
select id from t_27719_tgt where id > any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id >= any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id < any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id <= any (select id from t_27719_loc order by id limit 2) order by 1;

evaluate 'Case 8: ORDER SIBLINGS BY with LIMIT cuts rows before duplicates are removed';
-- the LIMIT becomes INST_NUM () and the ORDER BY stays
drop table if exists t_27719_h;
create table t_27719_h (id int, pid int, v int);
insert into t_27719_h values (10, null, 1), (11, 10, 1), (12, 10, 2), (13, null, 3);
select id from t_27719_tgt
 where id in (select v from t_27719_h start with pid is null connect by prior id = pid order siblings by id limit 2) order by 1;

evaluate 'Case 9: the join keeps duplicate outer rows, and EXCEPT ALL keeps duplicate values';
drop table if exists t_27719_td;
create table t_27719_td (id int);
insert into t_27719_td values (1), (1), (2);
select id from t_27719_td where id in (select id from t_27719_loc order by id limit 2) order by 1;
-- control: a build without the fix prints the same rows
select id from t_27719_td where id in (select id from t_27719_loc except all select id from t_27719_tgt where id = 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc except all select id from t_27719_tgt where id = 1) order by 1;

evaluate 'Case 10: the plans keep the join, a cut UNION ALL subquery is wrapped in a DISTINCT derived table and a plain IN stays a semi join';
--@queryplan
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc limit 3) order by 1;
-- control: a build without the fix prints the same plan
--@queryplan
select id from t_27719_tgt where id in (select id from t_27719_loc) order by 1;

evaluate 'Case 11: the row cut also holds in OR, an expression, HAVING, the select list, a nested IN, a CTE, INSERT SELECT, MERGE and PREPARE with a bound LIMIT';
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2) or id = 4 order by 1;
select id from t_27719_tgt where id + 0 in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt group by id having id in (select id from t_27719_loc order by id limit 2) order by 1;
select id, case when id in (select id from t_27719_loc order by id limit 2) then 1 else 0 end as hit from t_27719_tgt order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc where id in (select id from t_27719_loc order by id limit 2)) order by 1;
with c as (select id from t_27719_loc) select id from t_27719_tgt where id in (select id from c order by id limit 2) order by 1;
drop table if exists t_27719_ins;
create table t_27719_ins (id int);
insert into t_27719_ins select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2);
select id from t_27719_ins order by 1;
merge into t_27719_tgt t using (select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2)) s
 on (t.id = s.id) when matched then update set t.flag = 2;
select id from t_27719_tgt where flag = 2 order by 1;
--+ holdcas on;
prepare st from 'select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit ?) order by 1';
execute st using 2;
execute st using 3;
deallocate prepare st;
--+ holdcas off;

drop table if exists t_27719_h, t_27719_td, t_27719_ins;
drop table if exists t_27719_loc, t_27719_tgt, t_27719_ln, t_27719_tn;
