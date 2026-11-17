-- CBRD-27869: a range with a NULL bound (k between null and 500) is UNKNOWN for every row.
-- Range merging compared the NULL as the smallest value, so the range absorbed or bounded
-- the other ranges of the same column and their rows were lost (OR) or kept (AND).
-- The rewrite merged constant ranges that way and the index scan merged the key ranges
-- of run-time values ((select null)) that way, on ASC and DESC indexes.

drop table if exists t_a, t_d, t_m;

create table t_a (id int primary key, k int);
insert into t_a select rownum, mod (rownum, 100) from db_class a, db_class b limit 1000;
insert into t_a values (1001, null), (1002, null);
create index i_t_a_k on t_a (k);

create table t_d (id int primary key, k int);
insert into t_d select * from t_a;
create index i_t_d_k on t_d (k desc);

create table t_m (id int primary key, a int, b varchar (10));
insert into t_m select id, mod (id, 3), cast (k as varchar) from t_a;
create index i_t_m_ab on t_m (a, b);

update statistics on t_a, t_d, t_m with fullscan;

-- OR, constant NULL lower bound: 110 rows (k 10..20)
select count (*) from t_a where k between 10 and 20 or k between null and 50 using index none;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between null and 50;
select count (*) from t_d force index (i_t_d_k) where k between 10 and 20 or k between null and 50;

-- OR, run-time NULL lower bound: 110 rows
select count (*) from t_a where k between 10 and 20 or k between (select null) and 50 using index none;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between (select null) and 50;
select count (*) from t_d force index (i_t_d_k) where k between 10 and 20 or k between (select null) and 50;

-- three ranges with the NULL range in the middle: 160 rows (k 10..20, 60..64)
select count (*) from t_a where k between 10 and 20 or k between null and 50 or k between 60 and 64 using index none;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between (select null) and 50 or k between 60 and 64;
select count (*) from t_d force index (i_t_d_k) where k between 10 and 20 or k between (select null) and 50 or k between 60 and 64;

-- the rows themselves through the index, in both orders
select k, count (*) from t_a force index (i_t_a_k) where k between 10 and 12 or k between (select null) and 50 group by k order by k;
select k, count (*) from t_d force index (i_t_d_k) where k between 10 and 12 or k between (select null) and 50 group by k order by k desc;

-- AND with a NULL lower bound is UNKNOWN: 0 rows
select count (*) from t_a where k between 10 and 20 and k between null and 50 using index none;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 and k between null and 50;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 and k between (select null) and 50;

-- a NULL upper bound and NULL comparisons keep working: 110 rows
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between 15 and null;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between 15 and (select null);
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k < (select null);
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k > null;

-- an empty range is dropped from the key ranges, not left beside a merged unbounded range: 1000 rows
select count (*) from t_a force index (i_t_a_k) where k >= (select 10) or k <= (select 20) or k between (select null) and 50;
select count (*) from t_a force index (i_t_a_k) where k >= (select 10) or k <= (select 20) or k between (select 20) and 10;
select count (*) from t_d force index (i_t_d_k) where k between (select null) and 50 or k >= (select 10) or k <= (select 20);

-- a range skipped as disjoint is merged once the current range grows to reach it: 1000 rows
select count (*) from t_a force index (i_t_a_k) where k < (select 7) or k > (select 7) or k between (select 7) and (select 59);
select count (*) from t_d force index (i_t_d_k) where k < (select 7) or k > (select 7) or k between (select 7) and (select 59);
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k < (select 7) or k > (select 7) or k between (select 7) and (select 59) or k between null and 50;

-- NOT of the OR: rows with k > 50, 490 rows
select count (*) from t_a where not (k between 10 and 20 or k between null and 50) using index none;

-- ranges without NULL are still merged: 210 rows (k 10..30)
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between 15 and 30;
select count (*) from t_a force index (i_t_a_k) where k between 10 and 20 or k between (select 15) and 30;

-- multi-column index: 40 rows
select count (*) from t_m force index (i_t_m_ab) where a = 1 and (b between '10' and '20' or b between (select null) and '50');
select count (*) from t_m where a = 1 and b between '10' and '20' using index none;

drop table t_a, t_d, t_m;
