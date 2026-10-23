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

drop table if exists t_27719_loc, t_27719_tgt, t_27719_ln, t_27719_tn;
