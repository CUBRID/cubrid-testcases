/**
 *  CBRD-27820: the ORDER BY is not skipped when an index column is compared to a constant only in the ON
 *  condition of an outer join
 *
 *  An index scan already returns its rows in ORDER BY order when the index columns left out of the ORDER BY
 *  have one value in all scanned rows, and the optimizer then skips the sort. It took a column compared to a
 *  constant by '=' as having one value also when that comparison was in the ON condition of an outer join on
 *  the preserved table. That condition does not filter the rows of the preserved table, so the column kept
 *  several values and the rows came back in index order instead of ORDER BY order. Now only a constant that
 *  filters the scanned rows (WHERE, INNER JOIN ON, the ON of a semi join) lets the column be left out.
 *
 *  n1 (a, b, c) = (1, 1, 2), (1, 2, 1), index (a, b, c): ORDER BY a, c needs (1, 2, 1) before (1, 1, 2),
 *  which is not the index order.
 *  k1 (b, a) = (1, 2), (2, 1), index (b, a): ORDER BY a needs (2, 1) before (1, 2).
 *
 *  Coverage:
 *  1    LEFT OUTER JOIN, ON n1.b = 2 on the middle index column
 *  2    ON k1.b = 2 on the leading index column
 *  3    case 1 without WHERE, so the index is read by a full index scan
 *  4    case 1 behind an inner join on n1
 *  5    case 1 with ORDER BY DESC
 *  6    case 1 with LIMIT 1 when the LIMIT is applied to the n1 scan before the outer join
 *  7    RIGHT OUTER JOIN with n1 on the preserved side
 *  8    the sort is still skipped when the constant filters n1: WHERE, INNER JOIN ON, the ON of a semi join
 *       (EXISTS); and ON n1.b = 2 with ORDER BY a, b, c, the index order, is now skipped: b is no longer
 *       taken as fixed and left out of the index order
 *  9    a merge join that reads the n1 index scan as is (optimizer_enable_merge_join=yes): LEFT OUTER JOIN
 *       ON n1.b = 2 keeps the sort for ORDER BY a, c and skips it for ORDER BY a, b, c
 */

drop table if exists n1, k1, m2, p2;
create table n1 (a int not null, b int, c int);
create index i_n1 on n1 (a, b, c);
insert into n1 values (1, 1, 2), (1, 2, 1);
create table k1 (b int not null, a int not null);
create index i_k1 on k1 (b, a);
insert into k1 values (1, 2), (2, 1);
create table m2 (x int);
insert into m2 values (1);
create table p2 (a int);
create index i_p2 on p2 (a);
insert into p2 values (1);


evaluate 'Case 1: LEFT OUTER JOIN ON n1.b = 2; expect c = 1, 2';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 where n1.a > 0 order by n1.a, n1.c;


evaluate 'Case 2: ON k1.b = 2 on the leading index column; expect a = 1, 2';
--@queryplan
select /*+ recompile */ k1.b, k1.a from k1 left join m2 on k1.b = 2 where k1.b > 0 order by k1.a;


evaluate 'Case 3: case 1 without WHERE; expect c = 1, 2';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 order by n1.a, n1.c;


evaluate 'Case 4: case 1 behind an inner join on n1; expect c = 1, 2';
--@queryplan
select /*+ recompile ordered use_nl */ n1.a, n1.b, n1.c from n1 join p2 on p2.a = n1.a left join m2 on n1.b = 2 where n1.a > 0 order by n1.a, n1.c;


evaluate 'Case 5: case 1 with ORDER BY DESC; expect c = 2, 1';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 where n1.a > 0 order by n1.a desc, n1.c desc;


evaluate 'Case 6: LIMIT 1 over a LEFT OUTER JOIN whose ON also joins p2; expect (1, 2, 1)';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join p2 on n1.b = 2 and p2.a = n1.a where n1.a > 0 order by n1.a, n1.c limit 1;


evaluate 'Case 7: RIGHT OUTER JOIN with n1 preserved; expect c = 1, 2';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from m2 right join n1 on n1.b = 2 where n1.a > 0 order by n1.a, n1.c;


evaluate 'Case 8-1: WHERE n1.b = 2 filters n1; the sort may be skipped; expect (1, 2, 1)';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join m2 on m2.x = n1.c where n1.a > 0 and n1.b = 2 order by n1.a, n1.c;

evaluate 'Case 8-2: INNER JOIN ON n1.b = 2 filters n1; the sort may be skipped; expect (1, 2, 1)';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 inner join m2 on n1.b = 2 where n1.a > 0 order by n1.a, n1.c;

evaluate 'Case 8-3: the ON of a semi join (correlated EXISTS) filters n1; the sort may be skipped; expect (1, 2, 1)';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 where n1.a > 0 and exists (select 1 from m2 where n1.b = 2 and m2.x = n1.c) order by n1.a, n1.c;

evaluate 'Case 8-4: ON n1.b = 2 and ORDER BY all the index columns, in index order; expect b = 1, 2';
--@queryplan
select /*+ recompile */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 where n1.a > 0 order by n1.a, n1.b, n1.c;


set system parameters 'optimizer_enable_merge_join=yes';

evaluate 'Case 9-1: LEFT OUTER JOIN merge, ON n1.b = 2; the sort is kept; expect c = 1, 2';
--@queryplan
select /*+ recompile use_merge */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 and m2.x = n1.a where n1.a > 0 order by n1.a, n1.c;

evaluate 'Case 9-2: case 9-1 with ORDER BY all the index columns; the sort may be skipped; expect b = 1, 2';
--@queryplan
select /*+ recompile use_merge */ n1.a, n1.b, n1.c from n1 left join m2 on n1.b = 2 and m2.x = n1.a where n1.a > 0 order by n1.a, n1.b, n1.c;


set system parameters 'optimizer_enable_merge_join=no';

drop table n1, k1, m2, p2;
