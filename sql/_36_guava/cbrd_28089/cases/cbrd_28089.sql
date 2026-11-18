/*
 * This test case verifies CBRD-28089 : a join method hint that cannot be
 * applied to its join - USE_HASH or USE_MERGE on a join that has no hash
 * (mergeable) term, USE_IDX on an inner that has no index an idx-join could
 * use - is ignored for that join only, instead of failing the optimization
 * and dropping every hint of the query.
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
 *   Case 4: a non equi-join term (c.comp_cd < a.comp_cd, no constant) cannot
 *           be hashed either: LEADING(c,a) is kept (c -> a, the cost alone
 *           puts a first) and only USE_HASH(a) is ignored
 *   Case 5: hints that could be applied are unchanged: USE_HASH(b) makes a
 *           hash join, USE_HASH(c) without the constant makes a hash join,
 *           USE_NL(c), NO_USE_HASH(c) USE_HASH(c)
 *   Case 6: USE_IDX(d) on table_d that has no index, and USE_IDX(e) on
 *           table_e whose only index is on a column no term of the query
 *           reads: no idx-join is possible, the hint is ignored and the
 *           LEADING order is kept with a nl-join. USE_IDX(b) on a table with
 *           an index is applied as before
 *   Case 7: USE_IDX(h) on table_h that has no index while the join has an
 *           equi-join term: the hint is ignored for that join and every join
 *           method is left to the cost, which picks a hash join as without
 *           the hint (the nl-join alone was kept before the review fix)
 *   Case 8: USE_IDX(f) on table_f whose primary key starts with a column the
 *           join does not give (comp_cd, empno joined on empno only): no
 *           idx-join can be built, the hint is ignored and LEADING and
 *           USE_HASH(a) are kept. With comp_cd given too, USE_IDX(f) makes an
 *           idx-join as before
 *   Case 9: USE_IDX(ss) on a SEMI JOIN inner without an index: the inner may
 *           still be read first with the duplicates removed, the plan is the
 *           one without the hint (no HINT ignored)
 */
drop table if exists table_a, table_b, table_c, table_d, table_e, table_f, table_h, table_sb, table_ss;

create table table_a (comp_cd varchar(10) not null, empno varchar(30) not null, constraint pk_table_a primary key (comp_cd, empno));
create table table_b (comp_cd varchar(10) not null, empno varchar(50) not null, constraint pk_table_b primary key (comp_cd, empno));
create table table_c (comp_cd varchar(10) not null, wrk_dt datetime not null, constraint pk_table_c primary key (comp_cd, wrk_dt));
create table table_d (comp_cd varchar(10) not null, empno varchar(30) not null);
create table table_e (comp_cd varchar(10) not null, wrk_dt datetime not null, index idx_table_e_wrk_dt (wrk_dt));
create table table_f (comp_cd varchar(10) not null, empno varchar(30) not null, constraint pk_table_f primary key (comp_cd, empno));
create table table_h (empno varchar(30) not null, pad varchar(100));
create table table_sb (k int, v int, index i_table_sb_k (k));
create table table_ss (k int, v int);

insert into table_a select 'SEJO', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b limit 50;
insert into table_a select 'OTHR', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b limit 50;
insert into table_b select 'SEJO', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 10;
insert into table_b select 'OTHR', 'E' || rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 10;
insert into table_c select 'SEJO', datetime'2026-01-01 00:00:00' + rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 5;
insert into table_c select 'OTHR', datetime'2026-01-01 00:00:00' + rownum from table({0,1,2,3,4,5,6,7,8,9}) a limit 5;
insert into table_d select * from table_a;
insert into table_e select * from table_c;
insert into table_f select * from table_a;
insert into table_h select 'E' || rownum, 'pad' from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d limit 10000;
insert into table_sb select rownum, rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d, table({0,1,2,3,4,5,6,7,8,9}) e limit 100000;
insert into table_ss select mod(rownum, 5) + 1, rownum from table({0,1,2,3,4,5,6,7,8,9}) a, table({0,1,2,3,4,5,6,7,8,9}) b, table({0,1,2,3,4,5,6,7,8,9}) c, table({0,1,2,3,4,5,6,7,8,9}) d limit 10000;

update statistics on table_a, table_b, table_c, table_d, table_e, table_f, table_h, table_sb, table_ss with fullscan;

-- Case 1: the reported query
select /*+ recompile leading(b,a,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 2: LEADING(a,b,c) is kept with USE_HASH(c), USE_MERGE(c) and USE_HASH on every table
select /*+ recompile leading(a,b,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_merge(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_hash */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 3: USE_IDX(a) is kept
select /*+ recompile leading(b,a,c) use_hash(c) use_idx(a) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 4: a non equi-join term cannot be hashed either
select /*+ recompile leading(c,a) use_hash(a) */ count(*) from table_a a, table_c c where c.comp_cd < a.comp_cd;

-- Case 5: hints that can be applied are unchanged
select /*+ recompile leading(a,b,c) use_hash(b) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) use_nl(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

select /*+ recompile leading(a,b,c) no_use_hash(c) use_hash(c) */ count(*) from table_a a, table_b b, table_c c where a.comp_cd = 'SEJO' and a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = c.comp_cd;

-- Case 6: USE_IDX on an inner without an index an idx-join could use
select /*+ recompile leading(a,b,d) use_idx(d) */ count(*) from table_a a, table_b b, table_d d where a.comp_cd = b.comp_cd and a.empno = b.empno and a.empno = d.empno;

select /*+ recompile leading(a,b,e) use_idx(e) */ count(*) from table_a a, table_b b, table_e e where a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = e.comp_cd;

select /*+ recompile leading(a,b,d) use_idx(b) */ count(*) from table_a a, table_b b, table_d d where a.comp_cd = b.comp_cd and a.empno = b.empno and a.empno = d.empno;

-- Case 7: USE_IDX on an inner without an index, the join has an equi-join term
select /*+ recompile leading(a,h) use_idx(h) */ count(*) from table_a a, table_h h where a.empno = h.empno;

-- Case 8: USE_IDX on an inner whose index starts with a column the join does not give
select /*+ recompile leading(b,a,f) use_idx(f) use_hash(a) */ count(*) from table_a a, table_b b, table_f f where a.comp_cd = b.comp_cd and a.empno = b.empno and a.empno = f.empno;

select /*+ recompile leading(b,a,f) use_idx(f) use_hash(a) */ count(*) from table_a a, table_b b, table_f f where a.comp_cd = b.comp_cd and a.empno = b.empno and a.comp_cd = f.comp_cd and a.empno = f.empno;

-- Case 9: USE_IDX on a SEMI JOIN inner without an index
select /*+ recompile */ count(*), sum(sb.v) from table_sb sb semi join table_ss ss on ss.k = sb.k;

select /*+ recompile use_idx(ss) */ count(*), sum(sb.v) from table_sb sb semi join table_ss ss on ss.k = sb.k;

select /*+ recompile */ count(*), sum(sb.v) from table_sb sb where exists (select /*+ use_idx(ss) */ 1 from table_ss ss where ss.k = sb.k);

drop table table_a, table_b, table_c, table_d, table_e, table_f, table_h, table_sb, table_ss;
