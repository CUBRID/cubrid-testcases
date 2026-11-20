-- CBRD-28111: ORDER BY <key> LIMIT n must not keep an ordered key scan that the optimizer itself costs higher
-- than a top-N sort over another index's key range. The ordered scan of a plan that skips its ORDER BY (or
-- GROUP BY) is charged for the rows it reads before the LIMIT stops it, and the LIMIT comparisons of
-- qo_plan_cmp () go by cost like any other, without the 10 times wider band of CBRD-25080.

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

-- Case 1: LIMIT 200 of 267 estimated rows: the ordered pk scan would read most of the table, so the top-N sort
-- over the cid range is chosen
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id limit 200;

-- Case 2: LIMIT 5 of the same rows: the ordered pk scan stops after a few percent of the table and is kept
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id limit 5;

-- Case 3: Case 1 in descending order
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id desc limit 200;

-- Case 4: no index takes the filter: fewer rows than the LIMIT, so the ordered scan reads the whole table and
-- the sequential scan with a top-N sort wins; a small LIMIT keeps the ordered scan
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where amount = 7 order by id limit 200;
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where amount = 7 order by id limit 10;

-- Case 5: the filter range covers most of the table: the ordered scan stops early and is kept
--@queryplan
select /*+ recompile */ id, cid, amount from os_o where cid between 1 and 19000 order by id limit 200;

-- Case 6: join: the ordered pk scan driving a nested loop loses to a top-N sort over the grp range
--@queryplan
select /*+ recompile */ o.id, c.name from os_o o, os_c c where o.cid = c.cid and o.q = 7 and c.grp = 3 order by o.id limit 200;

-- Case 7: join with a small LIMIT: the ordered pk scan, dearer than the other scans of its table below the top
-- plan, still drives the nested loop
--@queryplan
select /*+ recompile */ o.id, c.name from os_o o, os_c c where o.cid = c.cid and c.grp = 3 order by o.id limit 5;

-- Case 8: GROUP BY skip stops at the LIMIT groups the same way
--@queryplan
select /*+ recompile */ id, count(*) from os_o where q = 7 and cid between 1000 and 2000 group by id limit 200;
--@queryplan
select /*+ recompile */ id, count(*) from os_o where q = 7 and cid between 1000 and 2000 group by id limit 5;

-- Case 9: a join that skips its GROUP BY up to the LIMIT groups (CBRD-27685) keeps its ordered driving scan
--@queryplan
select /*+ recompile */ o.id, count(*) from os_o o, os_c c where o.cid = c.cid and c.grp = 3 group by o.id limit 5;

-- Case 10: a LIMIT bound at run time is taken as many rows: the ordered scan is charged for its range
--@queryplan
prepare s from 'select /*+ recompile */ id, cid, amount from os_o where q = 7 and cid between 1000 and 2000 order by id limit ?';
--@queryplan
execute s using 200;
deallocate prepare s;

drop table os_o, os_c;
