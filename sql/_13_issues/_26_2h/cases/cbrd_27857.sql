/**
 *  This test case verifies CBRD-27857: an index join whose inner index scan has a range list
 *  or an IN list bounded by values of the outer row returns the error of a bound that fails,
 *  and cub_server does not abort.
 *
 *  The scan opens again for each outer row. When it shrinks its key list (a range dropped
 *  for a NULL bound, ranges merged, or an equal IN key dropped), it moves the later keys
 *  forward and lowers key_cnt only, so the entry after the last one keeps a copy of a key
 *  pointer that the scan has already cleared. When the next outer row fails to evaluate a
 *  bound, the cleanup clears every entry and clears that pointer a second time. The fix
 *  sets the two keys of that entry to NULL after each shrink.
 *
 *  Every query is an index join of ord and prd, the first rows of ord shrink the key list,
 *  and a later row divides by zero. A statement that fails prints no plan, so Case 5 runs
 *  the shape of each of Case 1 to Case 4 on rows that do not fail and shows the plan, which
 *  has idx-join and an index scan of prd. A build without the fix aborts the server at each
 *  of Case 1 to Case 4.
 *
 *  Coverage:
 *    Case 1:  a NULL lower bound drops a range, then a division by zero fails
 *    Case 2:  overlapping ranges are merged, then a division by zero fails
 *    Case 3:  an equal key of an IN list is dropped, then a division by zero fails
 *    Case 4:  the same as Case 3 on a single column varchar key
 *    Case 5:  the shapes of Case 1 to Case 4 return their rows and their plan when no bound fails
 *    Case 6:  the bound that fails is the last key of the IN list
 */

drop table if exists prd, ord;

-- id 1 and 2 shrink and fail in Case 1 (qty null, then 0), id 3 and 4 shrink and id 5 fails in Case 2, 3, 4 and 6
create table ord (id int primary key, grp int, amount int, qty int);
insert into ord values (1, 1, 100, null), (2, 1, 100, 0), (3, 1, 10, 1), (4, 1, 11, 1), (5, 1, 12, 0);
create table prd (id int primary key, grp int, price int, code varchar(10));
insert into prd values (1, 1, 10, 'P10'), (2, 1, 20, 'P20'), (3, 1, 30, 'P30'), (4, 1, 40, 'P40'), (5, 1, 50, 'P50'), (6, 1, 60, 'P60'), (7, 1, 70, 'P70'), (8, 1, 80, 'P80'), (9, 1, 95, 'P95');
create index i_prd_grp_price on prd (grp, price);
create index i_prd_code on prd (code);
update statistics on ord, prd with fullscan;


evaluate 'Case 1: a NULL lower bound drops a range, then a division by zero fails; result = error';
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id <= 2 and prd.grp = ord.grp and (prd.price between ord.amount / ord.qty and 50 or prd.price between 70 and 90)
order by 1, 2;


evaluate 'Case 2: overlapping ranges are merged, then a division by zero fails; result = error';
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id >= 3 and prd.grp = ord.grp and (prd.price between ord.amount / ord.qty and 50 or prd.price between 40 and 60 or prd.price between 70 and 90)
order by 1, 2;


evaluate 'Case 3: an equal key of an IN list is dropped, then a division by zero fails; result = error';
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id >= 3 and prd.grp = ord.grp and prd.price in (ord.amount / ord.qty, ord.amount, 30)
order by 1, 2;


evaluate 'Case 4: an equal key of a varchar IN list is dropped, then a division by zero fails; result = error';
select /*+ ordered use_nl */ ord.id, prd.code
from ord, prd force index (i_prd_code)
where ord.id >= 3 and prd.code in ('P' || (ord.amount / ord.qty), 'P' || ord.amount, 'P30')
order by 1, 2;


evaluate 'Case 5: the shapes of Case 1 to Case 4 return their rows and their plan when no bound fails';
-- Case 1 on id 1: the NULL bound drops its range and the range 70 to 90 is left
--@queryplan
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id = 1 and prd.grp = ord.grp and (prd.price between ord.amount / ord.qty and 50 or prd.price between 70 and 90)
order by 1, 2;
-- Case 2 on id 3 and 4
--@queryplan
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id between 3 and 4 and prd.grp = ord.grp and (prd.price between ord.amount / ord.qty and 50 or prd.price between 40 and 60 or prd.price between 70 and 90)
order by 1, 2;
-- Case 3 on id 3 and 4
--@queryplan
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id between 3 and 4 and prd.grp = ord.grp and prd.price in (ord.amount / ord.qty, ord.amount, 30)
order by 1, 2;
-- Case 4 on id 3 and 4
--@queryplan
select /*+ ordered use_nl */ ord.id, prd.code
from ord, prd force index (i_prd_code)
where ord.id between 3 and 4 and prd.code in ('P' || (ord.amount / ord.qty), 'P' || ord.amount, 'P30')
order by 1, 2;


evaluate 'Case 6: the bound that fails is the last key of the IN list; result = error';
-- the failing key is the last one, so the loop that sets the keys has already overwritten every entry when the cleanup runs
select /*+ ordered use_nl */ ord.id, prd.price
from ord, prd force index (i_prd_grp_price)
where ord.id >= 3 and prd.grp = ord.grp and prd.price in (ord.amount, ord.amount, ord.amount / ord.qty)
order by 1, 2;


drop table prd, ord;
