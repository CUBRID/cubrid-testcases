/**
 * This test case verifies CBRD-27259: STORAGE FORCE_INLINE
 * Scenario: ALTER ... STORAGE FORCE_INLINE on a column whose existing values are already in OOS.
 * Description: ALTER does not move stored values, so a large value already in OOS stays there. If any
 *              existing row would no longer fit in a page under FORCE_INLINE, the ALTER fails with
 *              ER_HEAP_OOS_OVERPASS_MAXOBJ_SIZE and the column keeps its previous storage setting.
 *              Otherwise every later UPDATE of that row, and loading its unloaded data, would fail.
 * Coverage: plain table, partitioned table, a row that still fits, and the ALTER after the large row is gone.
 */

drop table if exists t_article;
drop table if exists t_part;

-- a 20000-byte value is demoted to OOS; a 5000-byte value would fit inline
create table t_article (id int, view_count int, content bit varying);
insert into t_article values (1, 0, cast(repeat('AA', 20000) as bit varying));
insert into t_article values (2, 0, cast(repeat('AA', 5000) as bit varying));

-- fails: row 1 would need 20056 bytes inline
alter table t_article modify content bit varying storage force_inline;
show create table t_article;

-- the policy is unchanged, so an unrelated UPDATE of row 1 still works
update t_article set view_count = view_count + 1 where id = 1;
select id, view_count, bit_length (content) / 8 as bytes from t_article order by id;

-- without the large row, the ALTER succeeds and the remaining row stays updatable
delete from t_article where id = 1;
alter table t_article modify content bit varying storage force_inline;
show create table t_article;
update t_article set view_count = view_count + 1 where id = 2;
select id, view_count, bit_length (content) / 8 as bytes from t_article order by id;

-- partitioned table: every partition is checked
create table t_part (id int, c bit varying) partition by hash (id) partitions 2;
insert into t_part values (1, cast(repeat('AA', 20000) as bit varying));
insert into t_part values (2, cast(repeat('AA', 100) as bit varying));
alter table t_part modify c bit varying storage force_inline;
show create table t_part;
delete from t_part where id = 1;
alter table t_part modify c bit varying storage force_inline;
show create table t_part;
select id, bit_length (c) / 8 as bytes from t_part order by id;

drop table t_article;
drop table t_part;
