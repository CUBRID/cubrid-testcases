-- This test case verifies the CBRD-25164 issue.
-- The issue involves incorrect search results from covered index queries using function indexes.

select '-- Verify correct results are returned for basic select query with function index.';
drop table if exists tx;

create table tx (id int, va int, vb int, vc int, index idx(va, ln(va), vc));
insert into tx values (1,1,1,1), (2,2,2,2);
update statistics on tx;
select /*+ recompile */ vc from tx where va = 1;
select /*+ recompile */ vc from tx where va = 1 and vc > 0;

drop table tx;

select '-- Test with different data and more complex function index to ensure correct filtering.';
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values(1,1,10,100), (2,2,20,200);
create index idx on tx(va, ln(vb), vc);
update statistics on tx;
select /*+ recompile */ vc from tx where va = 1 and vc = 100;
select /*+ recompile */ ln(vb), vc from tx where va = 1 and vc = 100;
select /*+ recompile */ vb, ln(vb), vc from tx where va = 1 and vc = 100;
select /*+ recompile */ vc from tx where va > 1 and vc = 100;

drop index idx on tx;
create index idx on tx(va, ln(va), vc);
update statistics on tx;
select /*+ recompile */ vc from tx where va = 1 and vc = 100;
select /*+ recompile */ vc from tx where ln(va) >0 order by vc;
select /*+ recompile */ vc from tx where vc >0 order by vc;

drop index idx on tx;
create index idx on tx(va, ln(va), vc, vb);
update statistics on tx;
select /*+ recompile */ vc from tx where va = 1 and vc = 100;
select /*+ recompile */ ln(va), vb, vc from tx where va = 1 and vc = 100;

drop index idx on tx;
create index idx on tx(ln(va), vb, vc);
create index idx_length on tx(length(vb), va, vc);
update statistics on tx;
select /*+ recompile */ vc from tx where ln(va) > 0 and vc = 100;
select /*+ recompile */ va, vc from tx where length(vb) = 2 and vc = 100;
select /*+ recompile */ va, vc from tx where length(vb) = 2 and vc > 100;

drop table tx;


select '-- Scenario 1: Various function indexes and conditions in query';
-- Purpose: To verify the accuracy of queries using function indexes with various mathematical functions such as ln(), exp(), sqrt().
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values (1,10,100,1000), (2,20,200,2000);
create index idx_ln on tx(ln(va));
create index idx_exp on tx(exp(vb));
create index idx_sqrt on tx(sqrt(vc));
update statistics on tx;
select /*+ recompile */ vc from tx where ln(va) > 0;
select /*+ recompile */ vc from tx where exp(vb) < 1000;
select /*+ recompile */ vc from tx where sqrt(vc) > 30;

drop table tx;

select '-- Scenario 2: Queries including join operations';
-- Purpose: To verify the accuracy of join operations on tables with function indexes.
drop table if exists tx;
drop table if exists ty;

create table tx (id int, va int, vb int);
create table ty (id int, tx_id int, vc int);
insert into tx values (1,10,100), (2,20,200);
insert into ty values (1,1,1000), (2,2,2000);
create index idx on tx(id, ln(va), vb);
update statistics on tx;
select /*+ recompile */ ty.id, tx.vb, ty.vc from tx join ty on tx.id = ty.tx_id where vb > 2;

drop table tx;
drop table ty;

select '-- Scenario 3: Comparison with and without index hints';
-- Purpose: To compare the query results with and without using index hints like NO_COVERING_IDX.
drop table if exists tx;

create table tx (id int, va int, vb int, vc int);
insert into tx values (1,1,10,100), (2,2,20,200), (3,3,30,300);
create index idx on tx(va, ln(vb), vc);
update statistics on tx;

select '-- Query without index hint';
select /*+ recompile */ vc from tx where va = 1 and vc = 100;

select '-- Query with index hint NO_COVERING_IDX';
select /*+ recompile NO_COVERING_IDX */ vc from tx where va = 1 and vc = 100;

drop table tx;

