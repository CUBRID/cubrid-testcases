/**
 *  This test case verifies CBRD-27848: a descending index scan whose start limit is a constant of another type
 *  returns the same rows as a sequential scan
 *
 *  A DOUBLE limit such as 1152921504606846976.0e0 (2 to the 60th) compares equal to several BIGINT keys near it.
 *  The descending scan of the index (g, b) starts at the first or the last of those keys, by the kind of the limit.
 *  When the latch on the leaf to the left failed before the first key was read, the scan searched the limit again
 *  in the current leaf and started at an arbitrary equal key, or raised an error on a second failure. The fix
 *  restarts the scan from the root in that case. A latch failure needs a concurrent writer, so these cases pin
 *  the answer of the same scans without one.
 *
 *  Coverage:
 *    Case 1:  b below a DOUBLE limit, descending index scan, returns the three keys below the equal keys
 *    Case 2:  the same limit as a host variable returns the same three keys
 *    Case 3:  b up to a DOUBLE limit, descending index scan, returns the equal keys and the three keys below
 *    Case 4:  the sequential scans return the same rows as Cases 1 and 3
 *    Case 5:  a BIGINT limit equal to one key returns the keys below it only
 */

drop table if exists t_desc_mix;
create table t_desc_mix (g int, b bigint);
create index i_desc_mix_gb on t_desc_mix (g, b);

-- 2,754 rows of g = 2 fill several leaves before the g = 3 keys, so the descending scans of g = 3 start in a leaf
-- whose left neighbour holds g = 2 keys (the shape of the CBRD-27848 report)
insert into t_desc_mix select 2, rownum from db_root connect by level <= 2754;
-- three keys far below 2 to the 60th, five keys that a DOUBLE 2 to the 60th compares equal to, one key far above
insert into t_desc_mix values (3, 1), (3, 2), (3, 3);
insert into t_desc_mix select 3, 1152921504606846976 + rownum - 3 from db_root connect by level <= 5;
insert into t_desc_mix values (3, 4611686018427387904);

evaluate 'Case 1: b below a DOUBLE limit, descending index scan; result = 3, 2, 1';
--@queryplan
select /*+ recompile use_desc_idx */ b from t_desc_mix where g = 3 and b < 1152921504606846976.0e0 using index i_desc_mix_gb order by b desc;

evaluate 'Case 2: the same limit as a host variable; result = 3, 2, 1';
prepare q_excl from 'select /*+ recompile use_desc_idx */ b from t_desc_mix where g = 3 and b < ? using index i_desc_mix_gb order by b desc';
execute q_excl using 1152921504606846976.0e0;
deallocate prepare q_excl;

evaluate 'Case 3: b up to a DOUBLE limit, descending index scan; result = the five equal keys, then 3, 2, 1';
--@queryplan
select /*+ recompile use_desc_idx */ b from t_desc_mix where g = 3 and b <= 1152921504606846976.0e0 using index i_desc_mix_gb order by b desc;

evaluate 'Case 4: the sequential scans return the rows of Cases 1 and 3';
select /*+ recompile */ b from t_desc_mix where g = 3 and b < 1152921504606846976.0e0 using index none order by b desc;
select /*+ recompile */ b from t_desc_mix where g = 3 and b <= 1152921504606846976.0e0 using index none order by b desc;

evaluate 'Case 5: a BIGINT limit equal to one key returns the keys below it only; result = 1152921504606846975, 1152921504606846974, 3, 2, 1';
select /*+ recompile use_desc_idx */ b from t_desc_mix where g = 3 and b < 1152921504606846976 using index i_desc_mix_gb order by b desc;

drop table t_desc_mix;
