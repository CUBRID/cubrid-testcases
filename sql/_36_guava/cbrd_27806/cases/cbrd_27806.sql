/*
 * CBRD-27806: GREATEST, LEAST, COALESCE, CASE and DECODE whose argument fails the type check
 * after constant folding replaced it.
 *
 * To find the common type of a recursive expression, the type of each argument is checked in
 * advance. In that check, constant folding can replace the argument with a new node and free the
 * original one, for example a CASE with a constant condition reduced to one of its branches. When
 * an error was raised in the same check, for example the coercion of the other branch to DATETIME,
 * the new node was lost and the argument kept pointing to the freed node, so the client crashed.
 * Each statement below must now fail with the coercion error, and the same expressions without
 * the error must still return their values.
 *
 * Coverage:
 *   Case 1: the reported query and the folded branch on either side (THEN kept, ELSE kept)
 *   Case 2: LEAST, COALESCE, DECODE and a nested GREATEST in a CASE branch
 *   Case 3: the same expression in WHERE, ORDER BY, HAVING, a subquery, UPDATE, INSERT and CREATE VIEW
 *   Case 4: the same expressions with branches of a compatible type return their values
 */
drop view if exists v_27806;
drop table if exists t_27806;
create table t_27806 (i int primary key, e enum('a', 'b', '12'), dtm datetime, s varchar(10));
insert into t_27806 values (1, 'a', datetime'2020-01-02 03:04:05.006', 'x'), (2, '12', datetime'2021-06-30 23:59:59.500', 'y'), (3, null, null, null);


evaluate 'Case 1: the reported query, then the folded branch on either side';
select greatest(e, case when 1 = 1 then dtm else 2 end) from t_27806 order by i;
select greatest(e, case when 0 = 1 then dtm else 2 end) from t_27806 order by i;
select greatest(e, case when 0 = 1 then 2 else dtm end) from t_27806 order by i;
select greatest(e, case when 1 = 1 then 2 else dtm end) from t_27806 order by i;


evaluate 'Case 2: LEAST, COALESCE, DECODE and a nested GREATEST';
select least(e, case when 1 = 1 then dtm else 2 end) from t_27806 order by i;
select coalesce(case when 1 = 1 then dtm else 2 end, s) from t_27806 order by i;
select greatest(e, decode(1, 1, dtm, 2)) from t_27806 order by i;
select case when i = 1 then e else greatest(s, case when 1 = 1 then dtm else 2 end) end from t_27806 order by i;


evaluate 'Case 3: the same expression in other clauses and statements';
select i from t_27806 where greatest(e, case when 1 = 1 then dtm else 2 end) = 'a' order by i;
select i from t_27806 order by greatest(e, case when 1 = 1 then dtm else 2 end);
select i from t_27806 group by i having max(greatest(e, case when 1 = 1 then dtm else 2 end)) > 'a' order by i;
select (select greatest(e, case when 1 = 1 then dtm else 2 end) from t_27806 limit 1) from t_27806 order by i;
update t_27806 set s = greatest(e, case when 1 = 1 then dtm else 2 end);
insert into t_27806 (i, s) select i + 10, greatest(e, case when 1 = 1 then dtm else 2 end) from t_27806;
create view v_27806 as select greatest(e, case when 1 = 1 then dtm else 2 end) c from t_27806;
select * from t_27806 order by i;


evaluate 'Case 4: compatible branches return their values';
select i, greatest(e, case when 1 = 1 then s else 'z' end) from t_27806 order by i;
select i, coalesce(case when 1 = 1 then dtm else datetime'2000-01-01 00:00:00' end, datetime'1999-12-31 00:00:00') from t_27806 order by i;
select i, decode(i, 1, e, case when 1 = 1 then s else 'z' end) from t_27806 order by i;
select i, case when i = 1 then e else greatest(s, case when 1 = 0 then 'z' else s end) end from t_27806 order by i;


drop view if exists v_27806;
drop table t_27806;
