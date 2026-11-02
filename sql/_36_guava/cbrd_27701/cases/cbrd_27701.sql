/*
 * This test case verifies CBRD-27701 : the default (sampling) UPDATE STATISTICS
 * underestimated the distinct prefix counts (pkeys) of a multi-column index
 * whose prefix holds a NUMERIC, BIT VARYING, DOUBLE, FLOAT, MONETARY or BIGINT
 * key, and the join plans changed even with histograms.
 *
 * Bug: CBRD-26903 estimates the pkeys of a large index (over 5,000 pages,
 * not WITH FULLSCAN) by counting distinct prefix hashes in a key sample
 * (Duj1). The hash was mht_valhash (), which folds distinct values together:
 * every fixed NUMERIC and BIT string whose first byte is 0 hashes to 0,
 * FLOAT, DOUBLE and MONETARY are truncated to integers, BIGINT xors its two
 * halves. 800,000 distinct keys were counted as 1,025. The inner index scan
 * of an index join is priced with 1/pkeys, so the optimizer expected about
 * 780 rows per probe of ta and avoided ta as the inner table.
 *
 * Fix: the Duj1 prefix hash mixes the whole value of each key element.
 *
 * Data: ta 800,000 rows, ka/kd/km/kb/kg are distinct per row (NUMERIC,
 * DOUBLE, MONETARY, BIT VARYING with first byte 0, BIGINT with
 * hi xor lo in 0..1023), each the first column of an index padded with
 * cc CHAR (120) so that the index exceeds the sampling threshold.
 * cd = 5 is 400 rows, ce = 5 is 40,000 rows. tb has the same keys with
 * cd = 5 for 200 rows.
 *   Case 1: NUMERIC key, ta.cd = 5 -> idx-join, outer tb, inner ta
 *           (the bug picks ta as the outer table)
 *   Case 2: NUMERIC key, ta.ce = 5 -> idx-join, outer tb, inner ta
 *           (the bug picks a hash join reading 40,000 rows of ta)
 *   Case 3..6: the same as Case 2 with a DOUBLE, MONETARY, BIT VARYING
 *           and BIGINT key
 *   Case 7: control, constant terms on the NUMERIC index -> iscan,
 *           the same before and after the fix
 * Every result count is 200 (1 for Case 7) before and after the fix.
 */
drop table if exists ta, tb;

create table ta (ka numeric (10, 0), kd double, km monetary, kb bit varying (32), kg bigint,
                 cb int, cc char (120), cd int, ce int);
insert into ta
  with recursive
    x (lv) as (select 1 union all select lv + 1 from x where lv < 800),
    y (lv) as (select 1 union all select lv + 1 from y where lv < 1000)
  select n, n / 1000000.0e0, n / 1000000.0e0,
         cast (concat ('00', lpad (hex (n), 6, '0')) as bit varying (32)),
         cast (mod (n, 1000) as bigint) * 4294967296 + n div 1000,
         mod (n, 10), 'x', mod (n, 2000), mod (n, 20)
    from (select (x.lv - 1) * 1000 + y.lv n from x, y) z;

create index i_ta_ka on ta (ka, cb, cc);
create index i_ta_kd on ta (kd, cb, cc);
create index i_ta_km on ta (km, cb, cc);
create index i_ta_kb on ta (kb, cb, cc);
create index i_ta_kg on ta (kg, cb, cc);
create index i_ta_cd on ta (cd);
create index i_ta_ce on ta (ce);

create table tb (ka numeric (10, 0), kd double, km monetary, kb bit varying (32), kg bigint, cd int);
insert into tb select ka, kd, km, kb, kg, mod (ka, 4000) from ta;

create index i_tb_ka on tb (ka);
create index i_tb_kd on tb (kd);
create index i_tb_km on tb (km);
create index i_tb_kb on tb (kb);
create index i_tb_kg on tb (kg);
create index i_tb_cd on tb (cd);

update statistics on ta, tb;

select count (*) from ta;
select count (*) from tb;

evaluate '[1] NUMERIC key, ta.cd = 5: idx-join, outer iscan tb, inner iscan ta on i_ta_ka';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.ka = tb.ka and ta.cd = 5 and tb.cd = 5;

evaluate '[2] NUMERIC key, ta.ce = 5: idx-join, outer iscan tb, inner iscan ta on i_ta_ka';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.ka = tb.ka and ta.ce = 5 and tb.cd = 5;

evaluate '[3] DOUBLE key: idx-join, outer iscan tb, inner iscan ta on i_ta_kd';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.kd = tb.kd and ta.ce = 5 and tb.cd = 5;

evaluate '[4] MONETARY key: idx-join, outer iscan tb, inner iscan ta on i_ta_km';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.km = tb.km and ta.ce = 5 and tb.cd = 5;

evaluate '[5] BIT VARYING key: idx-join, outer iscan tb, inner iscan ta on i_ta_kb';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.kb = tb.kb and ta.ce = 5 and tb.cd = 5;

evaluate '[6] BIGINT key: idx-join, outer iscan tb, inner iscan ta on i_ta_kg';
--@queryplan
select /*+ recompile */ count (*) from ta, tb where ta.kg = tb.kg and ta.ce = 5 and tb.cd = 5;

evaluate '[7] control, constant terms: iscan ta on i_ta_ka';
--@queryplan
select /*+ recompile */ count (*) from ta where ka = 5 and cb = 5 and cd = 5;

drop table ta, tb;
