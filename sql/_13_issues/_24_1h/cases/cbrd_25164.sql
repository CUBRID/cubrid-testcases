-- This test case verifies the CBRD-25164 issue.
-- The issue involves incorrect search results from covered index queries using function indexes.

-- Verify correct results are returned for basic select query with function index.
drop table if exists tx;

create table tx (id int, va int, vb int, vc int, index idx(va, ln(va), vc));
insert into tx values (1,1,1,1), (2,2,2,2);
update statistics on tx;
select vc from tx where va = 1;
select vc from tx where va = 1 and vc > 0;

drop table tx;

-- Test with different data and more complex function index to ensure correct filtering.
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values(1,1,10,100), (2,2,20,200);
create index idx on tx(va, ln(vb), vc);
update statistics on tx;
select vc from tx where va = 1 and vc = 100;

drop index idx on tx;
create index idx on tx(va, ln(va), vc);
update statistics on tx;
select vc from tx where va = 1 and vc = 100;

drop index idx on tx;
create index idx on tx(va, ln(va), vc, vb);
update statistics on tx;
select vb from tx where va = 1 and vc = 100;

drop index idx on tx;
create index idx on tx(ln(va), vb, vc);
update statistics on tx;
select vb from tx where ln(va) > 0 and vc = 100;

drop table tx;

-- Scenario 1: Various function indexes and conditions in query
-- Purpose: To verify the accuracy and performance of queries using function indexes with various mathematical functions such as ln(), exp(), sqrt().
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values (1,10,100,1000), (2,20,200,2000);
create index idx_ln on tx(ln(va));
create index idx_exp on tx(exp(vb));
create index idx_sqrt on tx(sqrt(vc));
update statistics on tx;
select id from tx where ln(va) > 0;
select id from tx where exp(vb) < 1000;
select id from tx where sqrt(vc) > 30;

drop table tx;

-- Scenario 2: Queries including join operations
-- Purpose: To verify the accuracy and performance of join operations on tables with function indexes.
drop table if exists tx;
drop table if exists ty;

create table tx (id int, va int, vb int);
create table ty (id int, tx_id int, vc int);
insert into tx values (1,10,100), (2,20,200);
insert into ty values (1,1,1000), (2,2,2000);
create index idx on tx(ln(va));
update statistics on tx;
select ty.id, tx.va, ty.vc from tx join ty on tx.id = ty.tx_id where ln(tx.va) > 2;

drop table tx;
drop table ty;

-- Scenario 3: Performance test with large data
-- Purpose: To verify the performance of function indexes with large amounts of data.
drop table if exists tx;

create table tx (id int, va int);
insert into tx (id, va) select generate_series, random()*100 from generate_series(1,100000);
create index idx on tx(ln(va));
update statistics on tx;
select count(*) from tx where ln(va) > 4;

drop table tx;

-- Scenario 4: Changing the order in composite indexes
-- Purpose: To verify the impact of changing the order of columns in composite indexes, including function columns, on query results and performance.
drop table if exists tx;

create table tx (id int, va int, vb int);
insert into tx values (1,10,100), (2,20,200);
create index idx_va_ln on tx(va, ln(vb));
create index idx_ln_va on tx(ln(vb), va);
update statistics on tx;
select id from tx where ln(vb) > 4 and va = 10;

drop table tx;

-- Scenario 5: Comparison with and without index hints
-- Purpose: To compare the query results and performance with and without using index hints like NO_COVERING_IDX.
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values (1,1,10,100), (2,2,20,200), (3,3,30,300);

-- Index creation with function
create index idx on tx(va, ln(vb), vc);
update statistics on tx;

-- Query without index hint
-- expected to use the function index created above, potentially leading to a covered index scan.
select vc from tx where va = 1 and vc = 100;

-- Query with index hint NO_COVERING_IDX
-- explicitly instructs the optimizer not to use a covering index if available, which should force a different execution path, potentially affecting performance.
select /*+ NO_COVERING_IDX */ vc from tx where va = 1 and vc = 100;

-- Additional comparison for performance analysis
-- more complex query to observe the performance impact more clearly. The idea is to measure the execution time with and without the index hint on a more complex query that might be more sensitive to the choice of execution path.
select /*+ NO_COVERING_IDX */ count(*) from tx where va > 0 and ln(vb) > 1 and vc < 300;
select count(*) from tx where va > 0 and ln(vb) > 1 and vc < 300;

drop table tx;

