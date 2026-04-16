-- CBRD-26541: Target table dropped via synonym in DROP statement with unspecified object type
--
-- Synonyms cannot be used in ALTER, DROP, RENAME, and TRUNCATE statements (per manual).
-- However, DROP without object type (e.g., 'drop s1') and without IF EXISTS
-- was missing the synonym check, allowing the target table to be dropped through the synonym.
-- Fix: synonym check is now performed regardless of IF EXISTS presence.

-- cleanup
drop table if exists t1;
drop view if exists v1;
drop synonym if exists s1;
drop synonym if exists s2;

-- create table and synonym
create table t1 (c1 int);
create synonym s1 for t1;

evaluate 'case1: DROP with type specified - table keyword specifies the object type, so it looks for a table named s1, not found';
drop table s1;


evaluate 'case2: DROP without type + IF EXISTS - synonym check exists in IF EXISTS path, t1 not dropped';
drop if exists s1;

select * from t1;
select * from s1;

evaluate 'case3: DROP without type + no IF EXISTS - synonym check added, error expected, t1 preserved';
drop s1;
select * from t1;
select * from s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;

evaluate 'case4: qualified name (schema-prefixed synonym) + DROP without type';
create table t1 (c1 int);
insert into t1 values (1);
create synonym s1 for t1;
drop public.s1;
select * from t1;
select * from s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;

evaluate 'case5: synonym pointing to a view - DROP restriction applies equally to view-targeting synonyms';
create table t1 (c1 int);
insert into t1 values (1);
create view v1 as select * from t1;
create synonym s1 for v1;
drop s1;
select * from v1;
select * from s1;

-- cleanup
drop if exists t1;
drop if exists v1;
drop synonym if exists s1;

evaluate 'case6: broken synonym (target object already dropped) - synonym check order does not produce unexpected error paths';
create table t1 (c1 int);
create synonym s1 for t1;
drop table t1;
drop s1;

-- cleanup
drop if exists t1;
drop synonym if exists s1;

evaluate 'case7: chained synonyms (synonym of synonym) - DROP does not propagate through synonym chain to the real object';
create table t1 (c1 int);
insert into t1 values (1);
create synonym s1 for t1;
create synonym s2 for s1;
drop s2;
select * from t1;
select * from s1;
-- cleanup
drop table if exists t1;
drop synonym if exists s1;
drop synonym if exists s2;
