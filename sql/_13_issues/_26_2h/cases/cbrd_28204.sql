/**
 *  This test case verifies CBRD-28204: a plan the optimizer gives up on leaves the WHERE cut at the term it was adding,
 *  and the statement runs with the terms before it alone
 *
 *  The optimizer cuts the next link of each WHERE term to register it alone, and a failed assertion beneath jumped
 *  out past the statement that puts the link back. The statement then ran without a plan and without the terms after
 *  the cut. The fix records each cut and puts it back before the optimizer gives up.
 *  The case gives up the plan because the function index expression after a subquery term keeps its mark once the
 *  bind value takes the place of its column (CBRD-28372). When that is fixed the optimizer no longer gives up on this
 *  statement, and the case stays as a check of its result.
 *
 *  Coverage:
 *    Case 1:  a SELECT and an UPDATE whose plan is given up keep every WHERE term: 1 row, 1 row updated
 */
evaluate 'Case 1: a SELECT and an UPDATE whose plan is given up keep every WHERE term: 1 row, 1 row updated';
drop table if exists k1;
create table k1 (id int, a int, b int, d int);
insert into k1 values (1, 5, 3, 0), (2, 2, 3, 0);
create index k1_m on k1 (mod (a, b));
prepare st from 'select id from k1 x where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ? order by 1';
execute st using 5;
deallocate prepare st;
prepare st from 'update k1 x set x.d = x.d + 1000 where x.id > (select 0 from db_root) and mod (x.a, x.b) = 2 and x.a = ?';
execute st using 5;
deallocate prepare st;
select id from k1 where d >= 1000 order by 1;
drop table k1;
