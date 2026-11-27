/*
 * CBRD-27719: a range predicate (IN, NOT IN, op ANY/SOME, op ALL) compares
 * against the set of values its subquery returns when run alone.
 * The subquery used to be made DISTINCT unconditionally, which changed that
 * set when rows are counted after DISTINCT:
 *   1. ORDER BY ... LIMIT, LIMIT m, n and FOR ORDERBY_NUM () kept the first
 *      n distinct values instead of the first n rows.
 *   2. ORDERBY_NUM () in the select list numbered the rows after DISTINCT.
 *   3. A set operation with LIMIT and no ORDER BY became UNION / INTERSECT
 *      before the LIMIT, and EXCEPT ALL became EXCEPT.
 * An uncorrelated IN rewritten into a join must still return each outer row
 * once when the subquery has duplicates.
 * Subqueries without such a row count keep the previous results.
 */

drop table if exists t_27719_loc, t_27719_tgt, t_27719_ln, t_27719_tn;

create table t_27719_loc (id int, v int);
create table t_27719_tgt (id int, flag int default 0);
create table t_27719_ln (v int);
create table t_27719_tn (id int);

-- id 1 appears twice: the first two rows by id are {1}, the first two distinct values are {1, 2}
insert into t_27719_loc values (1, 10), (1, 20), (2, 30), (3, 40);
insert into t_27719_tgt (id) values (1), (2), (3), (4);
-- NULL right after the cut: the first three rows are 1, 1, 5 and hold no NULL
insert into t_27719_ln values (1), (1), (null), (5);
insert into t_27719_tn values (1), (2), (3), (4), (5);

-- 1. row cut after ORDER BY
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id not in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id = any (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id > all (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id = all (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id for orderby_num () <= 2) order by 1;
-- the sort key is not in the select list
select id from t_27719_tgt where id in (select id from t_27719_loc order by v limit 2) order by 1;
-- tuple and correlated forms
select id from t_27719_tgt where (id, id) in (select id, id from t_27719_loc order by id limit 2) order by 1;
select t.id from t_27719_tgt t where t.id in (select l.id from t_27719_loc l where l.id <= t.id order by l.id limit 2) order by 1;
-- NULL at the cut
select id from t_27719_tn where id not in (select v from t_27719_ln order by v nulls last limit 3) order by 1;

-- 2. ORDERBY_NUM () in the select list
select id from t_27719_tgt where id in (select orderby_num () from t_27719_loc order by id) order by 1;

-- 3. set operations
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc order by 1 limit 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc limit 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc intersect all select id from t_27719_loc limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc except all select id from t_27719_tgt) order by 1;

-- 4. UPDATE and DELETE pick the same rows
update t_27719_tgt set flag = 1 where id in (select id from t_27719_loc order by id limit 2);
select id from t_27719_tgt where flag = 1 order by 1;
delete from t_27719_tgt where id not in (select id from t_27719_loc order by id limit 2);
select id from t_27719_tgt order by 1;
delete from t_27719_tgt;
insert into t_27719_tgt (id) values (1), (2), (3), (4);

-- 5. no row count after DISTINCT: same results as before
select id from t_27719_tgt where id in (select id from t_27719_loc limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc order by id) order by 1;
select id from t_27719_tgt where id in (select distinct id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc union select id from t_27719_loc limit 2) order by 1;

-- 6. forms the change does not reach: same results as before
-- ROWNUM without ORDER BY cuts rows before DISTINCT
select id from t_27719_tgt where id in (select id from t_27719_loc where rownum <= 2) order by 1;
-- the row cut wrapped in a derived table by hand
select id from t_27719_tgt where id in (select id from (select id from t_27719_loc order by id limit 2) x) order by 1;
-- a scalar comparison and EXISTS are not range predicates
select id from t_27719_tgt where id = (select id from t_27719_loc order by id limit 1) order by 1;
select id from t_27719_tgt where exists (select 1 from (select id from t_27719_loc order by id limit 2) x where x.id = t_27719_tgt.id) order by 1;


-- 7. inequality ANY: the derived table + MIN/MAX branch of the rewrite
select id from t_27719_tgt where id > any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id >= any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id < any (select id from t_27719_loc order by id limit 1, 2) order by 1;
select id from t_27719_tgt where id <= any (select id from t_27719_loc order by id limit 2) order by 1;

-- 8. ORDER SIBLINGS BY with LIMIT: the LIMIT becomes INST_NUM () and the ORDER BY stays
create table t_27719_h (id int, pid int, v int);
insert into t_27719_h values (10, null, 1), (11, 10, 1), (12, 10, 2), (13, null, 3);
select id from t_27719_tgt
 where id in (select v from t_27719_h start with pid is null connect by prior id = pid order siblings by id limit 2) order by 1;

-- 9. the join keeps duplicate outer rows, and EXCEPT ALL keeps duplicate values
create table t_27719_td (id int);
insert into t_27719_td values (1), (1), (2);
select id from t_27719_td where id in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_td where id in (select id from t_27719_loc except all select id from t_27719_tgt where id = 3) order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc except all select id from t_27719_tgt where id = 1) order by 1;

-- 10. the plan keeps the join
--@queryplan
select id from t_27719_tgt where id in (select id from t_27719_loc union all select id from t_27719_loc limit 3) order by 1;
--@queryplan
select id from t_27719_tgt where id in (select id from t_27719_loc) order by 1;

-- 11. other positions and statements
select id from t_27719_tgt where id in (select id from t_27719_loc order by id limit 2) or id = 4 order by 1;
select id from t_27719_tgt where id + 0 in (select id from t_27719_loc order by id limit 2) order by 1;
select id from t_27719_tgt group by id having id in (select id from t_27719_loc order by id limit 2) order by 1;
select id, case when id in (select id from t_27719_loc order by id limit 2) then 1 else 0 end as hit from t_27719_tgt order by 1;
select id from t_27719_tgt where id in (select id from t_27719_loc where id in (select id from t_27719_loc order by id limit 2)) order by 1;
with c as (select id from t_27719_loc) select id from t_27719_tgt where id in (select id from c order by id limit 2) order by 1;
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
