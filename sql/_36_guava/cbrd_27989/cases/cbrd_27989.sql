/**
 *  This test case verifies CBRD-27989: A selected ROWNUM takes the last row number on every row
 *  when an earlier analytic evaluation skips its sort by the index order
 *
 *  The index on column a lets the first analytic evaluation group (over (order by a)) skip its
 *  sort, and a later group (over (order by b, a)) still sorts. Before the fix the sorting group
 *  evaluated the selected ROWNUM (INST_NUM ()) too early, so every row got the last row number.
 *  After the fix ROWNUM follows the output row order. No query has an ORDER BY on purpose,
 *  because the output order is what ROWNUM numbers, and in Case 10 and Case 11 what the ROWNUM
 *  range cuts: the sort keys of every sorting group are unique, so that order is fixed.
 *  Case 10 and Case 11 keep a ROWNUM range in WHERE and select no ROWNUM: LEAD, LAG, NTILE,
 *  FIRST_VALUE and LAST_VALUE of the sorting group must still be computed from all rows.
 *  Case 12 and Case 13 print the trace of a case above, to show which path that case takes.
 *
 *  Coverage:
 *    Case 1:  SUM in the sorting group, the reproduction of the issue: ROWNUM is 1 to 12 in output order
 *    Case 2:  RANK in the sorting group: ROWNUM is 1 to 12 in output order
 *    Case 3:  LEAD and LAG in the sorting group: ROWNUM is 1 to 12 in output order
 *    Case 4:  NTILE, FIRST_VALUE and LAST_VALUE in the sorting group: ROWNUM is 1 to 12 in output order
 *    Case 5:  three evaluation groups, the last one sorts: ROWNUM is 1 to 12 in output order
 *    Case 6:  INST_NUM () and an expression over ROWNUM: both follow the output order
 *    Case 7:  ROWNUM predicate with LEAD in the sorting group: only the rows of the range are kept, numbered in output order
 *    Case 8:  LIMIT: the first 4 rows of the output keep ROWNUM 1 to 4
 *    Case 9:  only the first group, which skips its sort, is unchanged by the fix (control)
 *    Case 10: ROWNUM range without a selected ROWNUM, LEAD and LAG in the sorting group: values come from all rows
 *    Case 11: ROWNUM range without a selected ROWNUM, NTILE, FIRST_VALUE and LAST_VALUE in the sorting group: values come from all rows
 *    Case 12: the trace of Case 1 shows that the first group skips its sort and the second group sorts: ROWNUM is 1 to 12 in output order
 *    Case 13: the trace of Case 9 shows that its only group skips its sort (control)
 */
drop table if exists t27989;
create table t27989 (a int, b int, c int);
insert into t27989 select rownum, rownum mod 3, rownum mod 2 from db_class limit 12;
create index i_t27989_a on t27989 (a);

evaluate 'Case 1: SUM in the sorting group, ROWNUM is 1 to 12 in output order';
select rownum, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0;

evaluate 'Case 2: RANK in the sorting group, ROWNUM is 1 to 12 in output order';
select rownum, a, row_number () over (order by a), rank () over (order by b desc, a) from t27989 where a > 0;

evaluate 'Case 3: LEAD and LAG in the sorting group, ROWNUM is 1 to 12 in output order';
select rownum, a, sum (c) over (order by a), lead (a) over (order by b, a), lag (a, 2) over (order by b, a) from t27989 where a > 0;

evaluate 'Case 4: NTILE, FIRST_VALUE and LAST_VALUE in the sorting group, ROWNUM is 1 to 12 in output order';
select rownum, a, sum (c) over (order by a), ntile (4) over (order by b, a), first_value (a) over (order by b, a), last_value (a) over (order by b, a) from t27989 where a > 0;

evaluate 'Case 5: three evaluation groups, ROWNUM is 1 to 12 in output order';
select rownum, a, row_number () over (order by a), count (*) over (order by c, a), sum (a) over (order by b, a) from t27989 where a > 0;

evaluate 'Case 6: INST_NUM () and an expression over ROWNUM follow the output order';
select inst_num (), rownum + 100, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0;

evaluate 'Case 7: ROWNUM predicate with LEAD in the sorting group, ROWNUM follows the output order';
select rownum, a, row_number () over (order by a), lead (a) over (order by b, a) from t27989 where a > 0 and rownum <= 5;
select rownum, a, max (a) over (order by a), lead (a) over (order by b, a) from t27989 where a > 0 and rownum between 3 and 8;

evaluate 'Case 8: LIMIT keeps ROWNUM 1 to 4 on the first 4 output rows';
select rownum, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0 limit 4;

evaluate 'Case 9: only the first group, which skips its sort, ROWNUM is 1 to 12 as before the fix (control)';
select rownum, a, row_number () over (order by a), lead (a) over (order by a) from t27989 where a > 0;

-- unlike Case 7, no ROWNUM is selected here, only the range in WHERE uses it
evaluate 'Case 10: ROWNUM range without a selected ROWNUM, LEAD and LAG of the sorting group are computed from all rows';
select a, max (a) over (order by a), lead (a) over (order by b, a), lag (a, 2) over (order by b, a) from t27989 where a > 0 and rownum between 3 and 8;

evaluate 'Case 11: ROWNUM range without a selected ROWNUM, NTILE, FIRST_VALUE and LAST_VALUE of the sorting group are computed from all rows';
select a, max (a) over (order by a), ntile (4) over (order by b, a), first_value (a) over (order by b, a), last_value (a) over (order by b, a) from t27989 where a > 0 and rownum between 3 and 8;

-- same query as Case 1
evaluate 'Case 12: the trace of the reproduction shows the first group skipping its sort and the second group sorting, ROWNUM is 1 to 12 in output order; result = first ANALYTIC line sort: false, second sort: true';
set trace on;
select rownum, a, row_number () over (order by a), sum (c) over (order by b, a) from t27989 where a > 0;
show trace;
set trace off;

-- same query as Case 9
evaluate 'Case 13: the trace of the single group shows that its sort is skipped (control); result = one ANALYTIC line, sort: false';
set trace on;
select rownum, a, row_number () over (order by a), lead (a) over (order by a) from t27989 where a > 0;
show trace;
set trace off;

drop table t27989;
