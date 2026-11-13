/*
 * This test case verifies CBRD-28089 : a USE_HASH or USE_MERGE hint on a join
 * that has no hash (mergeable) term is ignored for that join only, instead of
 * failing the optimization and dropping every hint of the query.
 *
 * comp_cd = 'SEJO' on table_a is propagated to table_b and table_c, so the
 * join term a.comp_cd = c.comp_cd is always true (a dummy join term) and the
 * join with c is a cross join with no term a hash join or a merge join could
 * use. Before the fix, USE_HASH(c) made the planner skip the nl-join and the
 * idx-join of c while no hash join was possible, so no plan existed for the
 * LEADING order, the optimization failed and the retry ran without any hint
 * ([Warning: HINT ignored], join order chosen by the cost). Now the hint on c
 * is ignored and LEADING, USE_IDX and the hints of the other tables apply.
 *
 * Every case prints the query plan (plan shape only, cost and card are masked).
 *   Case 1: the reported query, LEADING(b,a,c) USE_HASH(c): no HINT ignored,
 *           b -> a -> c with c as a nl cross join
 *   Case 2: LEADING(a,b,c) with USE_HASH(c) / USE_MERGE(c) / USE_HASH:
 *           the order a -> b -> c is kept (the cost alone puts b first)
 *   Case 3: USE_HASH(c) USE_IDX(a): USE_IDX(a) is kept with the order
 *   Case 4: a non equi-join term (c.comp_cd < a.comp_cd) cannot be hashed
 *           either, the LEADING order is kept
 *   Case 5: hints that could be applied are unchanged: USE_HASH(b) makes a
 *           hash join, USE_HASH(c) without the constant makes a hash join,
 *           USE_NL(c), NO_USE_HASH(c) USE_HASH(c)
 */
drop table if exists table_a, table_b, table_c;

create table table_a (comp_cd varchar(10) not null, empno varchar(30) not null, constraint pk_table_a primary key (comp_cd, empno));
create table table_b (comp_cd varchar(10) not null, empno varchar(50) not null, constraint pk_table_b primary key (comp_cd, empno));
create table table_c (comp_cd varchar(10) not null, wrk_dt datetime not null, constraint pk_table_c primary key (comp_cd, wrk_dt));

insert into table_a select 'SEJO', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b limit 50;
insert into table_a select 'OTHR', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b limit 50;
insert into table_b select 'SEJO', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 10;
insert into table_b select 'OTHR', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 10;
insert into table_c select 'SEJO', datetime'2026-01-01 00:00:00' + rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 5;
insert into table_c select 'OTHR', datetime'2026-01-01 00:00:00' + rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 5;

update statistics on table_a, table_b, table_c with fullscan;

-- Case 1: the reported query
select /*+ recompile leading(b,a,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 2: LEADING(a,b,c) is kept with USE_HASH(c), USE_MERGE(c) and USE_HASH on every table
select /*+ recompile leading(a,b,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_merge(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_hash */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 3: USE_IDX(a) is kept
select /*+ recompile leading(b,a,c) use_hash(c) use_idx(a) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 4: a non equi-join term cannot be hashed either
select /*+ recompile leading(a,c) use_hash(c) */ count(*) from table_a a, table_c c where a.comp_cd = 'SEJO' and c.comp_cd < a.comp_cd;

-- Case 5: hints that can be applied are unchanged
select /*+ recompile leading(a,b,c) use_hash(b) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_nl(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) no_use_hash(c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

drop table table_a, table_b, table_c;
