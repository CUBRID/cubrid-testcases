-- CBRD-27989: a selected ROWNUM must follow the output row order when the first analytic
-- evaluation group skips its sort by the index order and a later group sorts.
-- Before the fix every row got the last row number.
drop table if exists t27989;
create table t27989 (a int, b int, c int);
insert into t27989 select rownum, rownum mod 3, rownum mod 2 from db_class limit 12;
create index i_t27989_a on t27989 (a);

-- Case 1: the reproduction with a unique key in the sorting group (SUM)
select rownum, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0;

-- Case 2: RANK in the sorting group
select rownum, a, row_number () over (order by a), rank () over (order by b desc, a) from t27989 where a > 0;

-- Case 3: LEAD and LAG in the sorting group
select rownum, a, sum (c) over (order by a), lead (a) over (order by b, a), lag (a, 2) over (order by b, a) from t27989 where a > 0;

-- Case 4: NTILE, FIRST_VALUE and LAST_VALUE in the sorting group
select rownum, a, sum (c) over (order by a), ntile (4) over (order by b, a), first_value (a) over (order by b, a), last_value (a) over (order by b, a) from t27989 where a > 0;

-- Case 5: three evaluation groups
select rownum, a, row_number () over (order by a), count (*) over (order by c, a), sum (a) over (order by b, a) from t27989 where a > 0;

-- Case 6: INST_NUM () and an expression over ROWNUM
select inst_num (), rownum + 100, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0;

-- Case 7: ROWNUM predicate with LEAD in the sorting group
select rownum, a, row_number () over (order by a), lead (a) over (order by b, a) from t27989 where a > 0 and rownum <= 5;
select rownum, a, max (a) over (order by a), lead (a) over (order by b, a) from t27989 where a > 0 and rownum between 3 and 8;

-- Case 8: LIMIT
select rownum, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0 limit 4;

-- Case 9: only the first group, which skips the sort (unchanged)
select rownum, a, row_number () over (order by a), lead (a) over (order by a) from t27989 where a > 0;

drop table t27989;
