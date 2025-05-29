-- Issue: improving the caching of correlated subqueries, including TYPE_SP.
-- Test Scenarios:
--  1. Queries should execute without caching
--  2. Subquery should execute with caching enabled.
--  3. Subquery should not be cached due to NO_SUBQUERY_CACHE hint. 


drop table if exists t;

create table t (c int);
insert into t values(1),(2),(3);

create or replace function jsp(c1 int, c2 int) return string deterministic as language java name 'SpTest.testInt_2(int, int) return string';

--  1. Queries should execute without caching
set trace on;
SELECT jsp(c,c) FROM t;
show trace;

--  2. Subquery should execute with caching enabled.
SELECT (SELECT jsp(c,c) FROM dual) FROM t;
show trace;

--  3. Subquery should not be cached due to NO_SUBQUERY_CACHE hint. 
SELECT (SELECT /*+ NO_SUBQUERY_CACHE */ jsp(c,c) FROM dual) FROM t;
show trace;

set trace off;

drop function jsp;
drop table if exists t;
