/**
 *  This test case verifies CBRD-27899: a multi-table DELETE whose hints take arguments or whose
 *  WITH clause remains deletes rows from the tables it names.
 *
 *  The statement text printed back from a DELETE is its XASL cache key. The target tables were
 *  printed with the last hint argument or the WITH clause in their place, so two DELETE
 *  statements that differ only in their targets got the same key, and the second one ran the
 *  cached plan of the first and deleted rows of a table it did not name. Trigger actions are
 *  stored from the same text.
 *
 *  Each of Case 1 to Case 4 deletes id 1 from ta and then id 2 from tb with the same hints or
 *  WITH clause. Literals are parameterized, so only the target tells the two statements apart.
 *  Expected: ta keeps 2 and tb keeps 1 (before the fix ta was empty and tb kept 1 and 2).
 *
 *  Coverage:
 *    Case 1:  USE_NL(tb) hint
 *    Case 2:  LOCK_TIMEOUT(5) hint
 *    Case 3:  WITH RECURSIVE clause
 *    Case 4:  WITH clause with a materialized CTE (an inlined CTE leaves no WITH clause)
 *    Case 5:  trigger actions: a multi-table DELETE on tb with USE_NL(ta) deletes from tb,
 *             and a single-table DELETE with LOCK_TIMEOUT(5) compiles and deletes from tb
 */

drop table if exists ta, tb, cbrd_27899_s1, cbrd_27899_s2;

create table ta (id int);
create table tb (id int);

evaluate 'Case 1: USE_NL(tb) hint';
insert into ta values (1), (2);
insert into tb values (1), (2);
delete /*+ use_nl(tb) */ ta from ta, tb where ta.id = tb.id and ta.id = 1;
delete /*+ use_nl(tb) */ tb from ta, tb where ta.id = tb.id and ta.id = 2;
select 'ta' t, id from ta union all select 'tb', id from tb order by 1, 2;

evaluate 'Case 2: LOCK_TIMEOUT(5) hint';
delete from ta;
delete from tb;
insert into ta values (1), (2);
insert into tb values (1), (2);
delete /*+ lock_timeout(5) */ ta from ta, tb where ta.id = tb.id and ta.id = 1;
delete /*+ lock_timeout(5) */ tb from ta, tb where ta.id = tb.id and ta.id = 2;
select 'ta' t, id from ta union all select 'tb', id from tb order by 1, 2;

evaluate 'Case 3: WITH RECURSIVE clause';
delete from ta;
delete from tb;
insert into ta values (1), (2);
insert into tb values (1), (2);
with recursive c as (select 1 as x) delete ta from ta, tb where ta.id = tb.id and ta.id = 1;
with recursive c as (select 1 as x) delete tb from ta, tb where ta.id = tb.id and ta.id = 2;
select 'ta' t, id from ta union all select 'tb', id from tb order by 1, 2;

evaluate 'Case 4: WITH clause with a materialized CTE';
delete from ta;
delete from tb;
insert into ta values (1), (2);
insert into tb values (1), (2);
with c as (select /*+ materialize */ 1 as x) delete ta from ta, tb, c where ta.id = tb.id and c.x = 1 and ta.id = 1;
with c as (select /*+ materialize */ 1 as x) delete tb from ta, tb, c where ta.id = tb.id and c.x = 1 and ta.id = 2;
select 'ta' t, id from ta union all select 'tb', id from tb order by 1, 2;

evaluate 'Case 5: trigger actions delete from the tables they name';
delete from ta;
delete from tb;
insert into ta values (1), (2), (3);
insert into tb values (1), (2), (3);
create table cbrd_27899_s1 (id int);
create table cbrd_27899_s2 (id int);
create trigger cbrd_27899_trg_hint after insert on cbrd_27899_s1
  execute delete /*+ use_nl(ta) */ tb from ta, tb where ta.id = tb.id and tb.id = obj.id;
create trigger cbrd_27899_trg_lock after insert on cbrd_27899_s2
  execute delete /*+ lock_timeout(5) */ from tb where tb.id = obj.id;
insert into cbrd_27899_s1 values (2);
insert into cbrd_27899_s2 values (3);
select 'ta' t, id from ta union all select 'tb', id from tb order by 1, 2;

drop trigger cbrd_27899_trg_hint;
drop trigger cbrd_27899_trg_lock;
drop table ta, tb, cbrd_27899_s1, cbrd_27899_s2;
