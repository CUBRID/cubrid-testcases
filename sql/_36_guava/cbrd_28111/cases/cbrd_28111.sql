-- CBRD-28111: ORDER BY <key> LIMIT n must not keep an ordered key scan that the optimizer itself costs higher
-- than a top-N sort over another index's key range. The ORDER BY skip rule in qo_plan_cmp () yields to the cost
-- when the competing SORT-LIMIT plan reads its rows through an index key range. Against a full scan with a
-- top-N sort the ordered scan is still kept (CBRD-26354).

drop table if exists os_o, os_c;

create table os_o (id int primary key, cid int, q int, amount int);
create index idx_os_o_cid on os_o (cid);
insert into os_o select rownum, mod (rownum * 7919, 20000) + 1, mod (rownum * 31, 97) + 1, mod (rownum, 5000)
  from db_attribute a, db_attribute b, db_class c limit 500000;
update statistics on os_o with fullscan;

create table os_c (cid int primary key, name varchar(20), grp int);
insert into os_c select rownum, 'c' || rownum, mod (rownum, 50) from db_attribute a, db_attribute b limit 20000;
create index idx_os_c_grp on os_c (grp);
update statistics on os_c with fullscan;

-- rows of the range: cid between 1000 and 2000 = 25025, and q = 7 among them = 256
select count(*) from os_o where cid between 1000 and 2000;
select count(*) from os_o where q = 7 and cid between 1000 and 2000;

-- Case 1: top-N sort over the cid range instead of the ordered pk scan that reads most of the table
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id limit 5;

-- Case 2: same in descending order
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id desc limit 5;

-- Case 3: no index takes the filter as a key range, so the competitor is a full scan with a top-N sort: keep the ordered scan
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where amount = 7 order by id limit 5;

-- Case 4: the filter range covers most of the table, so the ordered scan is cheaper and stays by cost
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where cid between 1 and 19000 order by id limit 5;

-- Case 5: join: the ordered pk scan driving a nested loop loses to a top-N sort over the grp range
--@queryplan
select /*+ recompile */ o.id, c.name from os_o o, os_c c where o.cid = c.cid and o.q = 7 and c.grp = 3 order by o.id limit 5;

-- Case 6: join without a filter index on either side: the ordered nested loop is kept
--@queryplan
select /*+ recompile */ o.id, c.name from os_o o, os_c c where o.cid = c.cid and o.amount = 7 order by o.id limit 5;

-- Case 7: GROUP BY skip is not affected
--@queryplan
select /*+ recompile */ id, count(*) from os_o where q = 7 and cid between 1000 and 2000 group by id limit 5;

drop table os_o, os_c;
