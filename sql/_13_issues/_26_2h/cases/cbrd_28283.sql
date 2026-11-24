/**
 *  This test case verifies CBRD-28283: an index MIN/MAX scan returned a wrong MAX over several key ranges, and a
 *  wrong MIN or MAX when it is not covering under index_scan_in_oid_order=yes
 *
 *  An index MIN/MAX scan reads the index once per direction and takes the value from the first row of each pass.
 *  The key ranges of an IN list or an OR of ranges were read from the smallest value in both passes, so the pass that
 *  reads the values descending took MAX from the first key range. Under index_scan_in_oid_order=yes a scan that is
 *  not covering sorted the rows it read by OID, so the first row of a pass was not the smallest or the largest key.
 *  The fix reads the key ranges from the last one in the pass that takes MAX, and keeps the index order in an index
 *  MIN/MAX scan.
 *
 *  Each MIN/MAX query is followed by the same query that reads the table with IGNORE INDEX, and the two results
 *  must match. The trace of each MIN/MAX query shows the min_max_only index scan. CTP masks the digits of a trace.
 *
 *  Coverage:
 *    Case 1:  MIN and MAX over an IN list, covering
 *    Case 2:  Case 1 with the USE_DESC_IDX hint
 *    Case 3:  MIN and MAX over an OR of ranges, not covering
 *    Case 4:  MAX alone over an IN list
 *    Case 5:  Case 1 over an index whose first column is descending
 *    Case 6:  Case 2 over an index whose first column is descending
 *    Case 7:  Case 3 over an index whose first column is descending
 *    Case 8:  Case 4 over an index whose first column is descending
 *    Case 9:  an IN list over an ascending single-column index, covering and not covering
 *    Case 10: Case 9 over a descending single-column index
 *    Case 11: an equality on the descending first column and an IN list on the ascending second column
 *    Case 12: an equality on the ascending first column and an IN list on the descending second column
 *    Case 13: index_scan_in_oid_order=yes, one key range, not covering, MIN alone, MAX alone, and both
 *    Case 14: index_scan_in_oid_order=yes, an IN list, not covering
 *    Case 15: index_scan_in_oid_order=yes, one key range, covering
 */

drop table if exists ta, tb;

create table ta (ca int primary key, cb int not null, cc int, cd varchar(10));
insert into ta
  with recursive r (n) as (select 1 union all select n + 1 from r where n < 2000)
  select n, mod (n, 12), mod (n, 7), decode (mod (n, 3), 0, 'x', 'y') from r;

create index i_ta_cb_cc on ta (cb, cc);
update statistics on ta with fullscan;

set trace on;

evaluate 'Case 1: MIN and MAX over an IN list, covering; result = ignore index';
select min (cb), max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cb_cc) where cb in (1, 5, 9) and cc > 0;

evaluate 'Case 2: Case 1 with the USE_DESC_IDX hint; result = ignore index';
select /*+ use_desc_idx */ min (cb), max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cb_cc) where cb in (1, 5, 9) and cc > 0;

evaluate 'Case 3: MIN and MAX over an OR of ranges, not covering; result = ignore index';
select min (cb), max (cb) from ta where (cb between 1 and 3 or cb between 7 and 9) and cd = 'y';
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cb_cc) where (cb between 1 and 3 or cb between 7 and 9) and cd = 'y';

evaluate 'Case 4: MAX alone over an IN list; result = ignore index';
select max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select max (cb) from ta ignore index (i_ta_cb_cc) where cb in (1, 5, 9) and cc > 0;

drop index i_ta_cb_cc on ta;
create index i_ta_cbd_cc on ta (cb desc, cc);
update statistics on ta with fullscan;

evaluate 'Case 5: Case 1 over an index whose first column is descending; result = ignore index';
select min (cb), max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cbd_cc) where cb in (1, 5, 9) and cc > 0;

evaluate 'Case 6: Case 2 over an index whose first column is descending; result = ignore index';
select /*+ use_desc_idx */ min (cb), max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cbd_cc) where cb in (1, 5, 9) and cc > 0;

evaluate 'Case 7: Case 3 over an index whose first column is descending; result = ignore index';
select min (cb), max (cb) from ta where (cb between 1 and 3 or cb between 7 and 9) and cd = 'y';
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cbd_cc) where (cb between 1 and 3 or cb between 7 and 9) and cd = 'y';

evaluate 'Case 8: Case 4 over an index whose first column is descending; result = ignore index';
select max (cb) from ta where cb in (1, 5, 9) and cc > 0;
show trace;
select max (cb) from ta ignore index (i_ta_cbd_cc) where cb in (1, 5, 9) and cc > 0;

drop index i_ta_cbd_cc on ta;
create index i_ta_cb on ta (cb);
update statistics on ta with fullscan;

evaluate 'Case 9: an IN list over an ascending single-column index, covering and not covering; result = ignore index';
select min (cb), max (cb) from ta where cb in (1, 5, 9);
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cb) where cb in (1, 5, 9);
select min (cb), max (cb) from ta where cb in (1, 5, 9) and cd = 'y';
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cb) where cb in (1, 5, 9) and cd = 'y';

drop index i_ta_cb on ta;
create index i_ta_cbd on ta (cb desc);
update statistics on ta with fullscan;

evaluate 'Case 10: Case 9 over a descending single-column index; result = ignore index';
select min (cb), max (cb) from ta where cb in (1, 5, 9);
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cbd) where cb in (1, 5, 9);
select min (cb), max (cb) from ta where cb in (1, 5, 9) and cd = 'y';
show trace;
select min (cb), max (cb) from ta ignore index (i_ta_cbd) where cb in (1, 5, 9) and cd = 'y';

drop index i_ta_cbd on ta;
create index i_ta_cbd_cc on ta (cb desc, cc);
update statistics on ta with fullscan;

evaluate 'Case 11: an equality on the descending first column and an IN list on the ascending second column; result = ignore index';
select min (cc), max (cc) from ta where cb = 5 and cc in (1, 3, 6);
show trace;
select min (cc), max (cc) from ta ignore index (i_ta_cbd_cc) where cb = 5 and cc in (1, 3, 6);

drop index i_ta_cbd_cc on ta;
create index i_ta_cb_ccd on ta (cb, cc desc);
update statistics on ta with fullscan;

evaluate 'Case 12: an equality on the ascending first column and an IN list on the descending second column; result = ignore index';
select min (cc), max (cc) from ta where cb = 5 and cc in (1, 3, 6);
show trace;
select min (cc), max (cc) from ta ignore index (i_ta_cb_ccd) where cb = 5 and cc in (1, 3, 6);

/* cb falls as ca rises in tb, so the row of tb with the smallest OID holds cb = 7, neither MIN nor MAX. A plan is
 * cached with its constants as host variables, so Cases 13 to 15 read tb and get plans made under the parameter. */
set system parameters 'index_scan_in_oid_order=yes';

create table tb (ca int primary key, cb int not null, cc int, cd varchar(10));
create index i_tb_cb_cc on tb (cb, cc);
insert into tb
  with recursive r (n) as (select 1 union all select n + 1 from r where n < 2000)
  select n, mod (2000 - n, 12), mod (n, 7), decode (mod (n, 3), 0, 'x', 'y') from r;
update statistics on tb with fullscan;

evaluate 'Case 13: index_scan_in_oid_order=yes, one key range, not covering, MIN alone, MAX alone, and both; result = ignore index';
select min (cb) from tb where cb between 1 and 9 and cd = 'y';
show trace;
select min (cb) from tb ignore index (i_tb_cb_cc) where cb between 1 and 9 and cd = 'y';
select max (cb) from tb where cb between 1 and 9 and cd = 'y';
show trace;
select max (cb) from tb ignore index (i_tb_cb_cc) where cb between 1 and 9 and cd = 'y';
select min (cb), max (cb) from tb where cb between 1 and 9 and cd = 'y';
show trace;
select min (cb), max (cb) from tb ignore index (i_tb_cb_cc) where cb between 1 and 9 and cd = 'y';

evaluate 'Case 14: index_scan_in_oid_order=yes, an IN list, not covering; result = ignore index';
select min (cb), max (cb) from tb where cb in (1, 5, 9) and cd = 'y';
show trace;
select min (cb), max (cb) from tb ignore index (i_tb_cb_cc) where cb in (1, 5, 9) and cd = 'y';

evaluate 'Case 15: index_scan_in_oid_order=yes, one key range, covering; result = ignore index';
select min (cb), max (cb) from tb where cb between 1 and 9 and cc > 0;
show trace;
select min (cb), max (cb) from tb ignore index (i_tb_cb_cc) where cb between 1 and 9 and cc > 0;

set trace off;
set system parameters 'index_scan_in_oid_order=default';

drop table ta, tb;
