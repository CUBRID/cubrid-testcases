/**
 *  This test case verifies CBRD-28306: plan selection between index skip or loose index scan
 *  and sort depends on index creation order.
 *
 *  qo_plan_cmp (a, b) compares a scan plan that skips ORDER BY or GROUP BY with a sort plan.
 *  An index skip scan or a loose index scan must be compared by cost, and only a b side
 *  scan was checked for that. Plans are generated in index order, so an index skip or loose
 *  index scan on the index created first came as a and won by the skip rule even when it
 *  cost more. The fix checks the a side as well.
 *
 *  Each query runs on two tables with the same rows and the same indexes, created in the
 *  opposite order, and the two results and plans must match. ta, tc and te create the index
 *  (ca, cb, cc) first, tb, td and tf create the index (cb) first.
 *
 *  Coverage:
 *    Case 1:  index skip scan that costs more than the sort plan, (ca, cb, cc) created first
 *    Case 2:  same as Case 1, (cb) created first
 *    Case 3:  loose index scan that costs more than the sort plan, (ca, cb, cc) created first
 *    Case 4:  same as Case 3, (cb) created first
 *    Case 5:  index skip scan that costs less than the sort plan, (ca, cb, cc) created first
 *    Case 6:  same as Case 5, (cb) created first
 *    Case 7:  loose index scan that costs less than the sort plan, (ca, cb, cc) created first
 *    Case 8:  same as Case 7, (cb) created first
 *    Case 9:  index range scan that skips ORDER BY, (ca, cb, cc) created first
 *    Case 10: same as Case 9, (cb) created first
 *    Case 11: index range scan that skips GROUP BY, (ca, cb, cc) created first
 *    Case 12: same as Case 11, (cb) created first
 */

drop table if exists ta, tb, tc, td, te, tf;

-- qo_plan_cmp () decides a LIMIT query by cost before the skip rules when one plan costs more than 10 times the other,
-- so each pair below keeps its two plans within that band.
-- ta, tb: 200,000 rows, 1,000 values of ca and 200 values of cb, so cb = 5 holds 1,000 rows. The index skip scan probes
-- each value of ca and costs about 2.4 times the sort plan over (cb), the loose index scan about 2.2 times.
create table ta (ca int, cb int, cc int);
create table tb (ca int, cb int, cc int);
insert into ta select mod (level, 1000), mod (level / 1000, 200), level from db_root connect by level <= 200000;
insert into tb select ca, cb, cc from ta;
create index i_ta_ca_cb_cc on ta (ca, cb, cc);
create index i_ta_cb on ta (cb);
create index i_tb_cb on tb (cb);
create index i_tb_ca_cb_cc on tb (ca, cb, cc);

-- tc, td: 200,000 rows, 100 values of ca and 10 values of cb, so cb = 5 holds 20,000 rows. The sort plan over (cb) costs
-- about 4 times the index skip scan.
create table tc (ca int, cb int, cc int);
create table td (ca int, cb int, cc int);
insert into tc select mod (level, 100), mod (level / 100, 10), level from db_root connect by level <= 200000;
insert into td select ca, cb, cc from tc;
create index i_tc_ca_cb_cc on tc (ca, cb, cc);
create index i_tc_cb on tc (cb);
create index i_td_cb on td (cb);
create index i_td_ca_cb_cc on td (ca, cb, cc);

-- te, tf: the rows of tc with 7 values of cc, which makes the index (ca, cb, cc) smaller, so that the sort plan over (cb)
-- costs about 1.25 times the loose index scan. With a distinct cc in each row, the loose index scan costs more.
create table te (ca int, cb int, cc int);
create table tf (ca int, cb int, cc int);
insert into te select ca, cb, mod (cc, 7) from tc;
insert into tf select ca, cb, cc from te;
create index i_te_ca_cb_cc on te (ca, cb, cc);
create index i_te_cb on te (cb);
create index i_tf_cb on tf (cb);
create index i_tf_ca_cb_cc on tf (ca, cb, cc);

update statistics on ta, tb, tc, td, te, tf with fullscan;

-- recompile: the TC checks the plan that qo_plan_cmp () picks, which runs only when the statement is compiled
evaluate 'Case 1: index skip scan that costs more, composite index first; result = sort plan over i_ta_cb';
--@queryplan
select /*+ recompile index_ss */ ca, cb, cc from ta where cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 2: index skip scan that costs more, (cb) first; result = sort plan over i_tb_cb';
--@queryplan
select /*+ recompile index_ss */ ca, cb, cc from tb where cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 3: loose index scan that costs more, composite index first; result = sort plan over i_ta_cb';
--@queryplan
select /*+ recompile index_ls */ ca, count (distinct cb) from ta where cb = 5 group by ca order by ca limit 3;

evaluate 'Case 4: loose index scan that costs more, (cb) first; result = sort plan over i_tb_cb';
--@queryplan
select /*+ recompile index_ls */ ca, count (distinct cb) from tb where cb = 5 group by ca order by ca limit 3;

evaluate 'Case 5: index skip scan that costs less, composite index first; result = index skip scan of i_tc_ca_cb_cc';
--@queryplan
select /*+ recompile index_ss */ ca, cb, cc from tc where cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 6: index skip scan that costs less, (cb) first; result = index skip scan of i_td_ca_cb_cc';
--@queryplan
select /*+ recompile index_ss */ ca, cb, cc from td where cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 7: loose index scan that costs less, composite index first; result = loose index scan of i_te_ca_cb_cc';
--@queryplan
select /*+ recompile index_ls */ ca, count (distinct cb) from te where cb = 5 group by ca order by ca limit 3;

evaluate 'Case 8: loose index scan that costs less, (cb) first; result = loose index scan of i_tf_ca_cb_cc';
--@queryplan
select /*+ recompile index_ls */ ca, count (distinct cb) from tf where cb = 5 group by ca order by ca limit 3;

-- Cases 9 to 12: no index hint, so the range scan of (ca, cb, cc) is a plain index scan. It costs about 1.6 times the sort plan
-- over (cb) and still wins by the skip rule, which the fix keeps for scans other than index skip and loose index scans.
evaluate 'Case 9: index range scan that skips ORDER BY, composite index first; result = index scan of i_ta_ca_cb_cc';
--@queryplan
select /*+ recompile */ ca, cb, cc from ta where ca between 0 and 699 and cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 10: index range scan that skips ORDER BY, (cb) first; result = index scan of i_tb_ca_cb_cc';
--@queryplan
select /*+ recompile */ ca, cb, cc from tb where ca between 0 and 699 and cb = 5 order by ca, cb, cc limit 3;

evaluate 'Case 11: index range scan that skips GROUP BY, composite index first; result = index scan of i_ta_ca_cb_cc';
--@queryplan
select /*+ recompile */ ca, max (cc) from ta where ca between 0 and 699 and cb = 5 group by ca order by ca limit 3;

evaluate 'Case 12: index range scan that skips GROUP BY, (cb) first; result = index scan of i_tb_ca_cb_cc';
--@queryplan
select /*+ recompile */ ca, max (cc) from tb where ca between 0 and 699 and cb = 5 group by ca order by ca limit 3;

drop table ta, tb, tc, td, te, tf;
