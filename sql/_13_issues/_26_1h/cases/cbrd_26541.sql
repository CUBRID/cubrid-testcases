-- CBRD-26541: Target table dropped via synonym in DROP statement with unspecified object type
--
-- Synonyms cannot be used in ALTER, DROP, RENAME, and TRUNCATE statements (per manual).
-- However, DROP without object type (e.g., 'drop s1') and without IF EXISTS
-- was missing the synonym check, allowing the target table to be dropped through the synonym.
-- Fix: synonym check is now performed regardless of IF EXISTS presence.

-- cleanup
drop table if exists t1;
drop synonym if exists s1;

-- create table and synonym
create table t1 (c1 int);
create synonym s1 for t1;  -- s1 is a synonym pointing to t1

-- case1: DROP with type specified (works correctly, same before/after fix)
-- 'table' keyword specifies the object type, so it looks for a table named s1 → not found
drop table s1;
-- ERROR: Class dba.s1 does not exist.

-- case2: DROP without type + IF EXISTS (works correctly, same before/after fix)
-- IF EXISTS path already had synonym check, so t1 is not dropped
-- s1 is a synonym, not a valid DROP target → no error due to IF EXISTS
drop if exists s1;
-- Execute OK. (but nothing is actually dropped)
select * from t1;
select * from s1;
-- There are no results.
-- 0 row selected. (t1 still exists)

-- case3: DROP without type + no IF EXISTS (BUG)
-- [before fix] synonym check missing → follows s1 to t1 and drops t1
-- [after fix] synonym check added → error "Class dba.s1 does not exist", t1 preserved
drop s1;
select * from t1;
select * from s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;

-- case4: qualified name (schema-prefixed synonym) + DROP without type
-- Verify synonym check is not bypassed when using schema.synonym_name
create table t1 (c1 int);
insert into t1 values (1);
create synonym s1 for t1;
drop public.s1;
select * from t1;
select * from s1;

-- cleanup
drop if exists t1;
drop if exists v1;
drop synonym if exists s1;

-- case5: synonym pointing to a view
-- Verify DROP restriction applies equally to view-targeting synonyms
create table t1 (c1 int);
insert into t1 values (1);
create view v1 as select * from t1;
create synonym s1 for v1;
drop s1;
select * from v1;
select * from s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;

-- case6: broken synonym (target object already dropped)
-- Verify synonym check order doesn't produce unexpected error paths
create table t1 (c1 int);
create synonym s1 for t1;
drop table t1;
drop s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;
drop synonym if exists s2;

-- case7: chained synonyms (synonym of synonym)
-- Verify DROP doesn't propagate through synonym chain to the real object
create table t1 (c1 int);
insert into t1 values (1);
create synonym s1 for t1;
create synonym s2 for s1;
drop s2;
select * from t1;
select * from s1;
