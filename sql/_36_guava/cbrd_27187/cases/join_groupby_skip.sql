/**
 *  CBRD-27187: a GROUP BY over a join can read the rows in the order of an index on the first
 *  table and skip the sort, as a GROUP BY on a single table already does.
 *
 *  An index scan with no key range is offered only because it returns the rows in GROUP BY
 *  order. Before the fix that scan was thrown away as soon as the statement had a join, even
 *  with a USING INDEX hint, so a GROUP BY over a join was always sorted. Now the sort is skipped
 *  when the join passes the rows of its first table on in index order: a nested loop join (inner
 *  or left outer) does, a hash join does not, and with a right outer join the GROUP BY column
 *  comes from the side that is filled with NULL. A partitioned table or a class hierarchy as the
 *  inner does not either: it is read one partition or class at a time and the first table is read
 *  again for each, so the rows of a group come apart.
 *
 *  Coverage:
 *  1    the reported queries: GROUP BY on tbl_a alone as the reference, and the same with a
 *       one-row cross join
 *  2    an inner join under a cross join, the index of tbl_a is two joins down
 *  3    left outer join, a tbl_a row without a match in tbl_b is counted in its group
 *  4    hash join, the GROUP BY is still sorted
 *  5    right outer join, the GROUP BY is still sorted and the tbl_b row without a match makes
 *       the NULL group
 *  6    partitioned table as the inner, the GROUP BY is still sorted
 *  7    class hierarchy as the inner, the GROUP BY is still sorted
 *  8    ROWNUM in the WHERE clause rules the skip out: the index scan is not even a candidate,
 *       with or without the USING INDEX hint, and the rows ROWNUM picks are the same as before
 */

drop table if exists tbl_a, tbl_b, tbl_c, tbl_d;
drop table if exists tbl_e1, tbl_e2;
drop table if exists tbl_e;

create table tbl_a (cola int primary key, colb int not null);
create index idx_colb on tbl_a (colb);
create table tbl_b (colc int primary key, cold int);
create index idx_cold on tbl_b (cold);
create table tbl_c (cole int);
create table tbl_d (colf int primary key, colg int)
  partition by range (colf) (partition p1 values less than (100), partition p2 values less than (200));
create index idx_colg on tbl_d (colg);
create table tbl_e (colh int primary key, coli int);
create table tbl_e1 under tbl_e;
create table tbl_e2 under tbl_e;
create index idx_coli on tbl_e (coli);

insert into tbl_a values (1, 3), (2, 1), (3, 2), (4, 1), (5, 3), (6, 2);
insert into tbl_b values (11, 1), (12, 2), (13, 2), (14, 4), (15, 5), (16, 6), (17, 6), (18, 9);
insert into tbl_c values (1);
insert into tbl_d values (11, 1), (12, 2), (13, 2), (14, 4), (115, 5), (116, 6), (117, 6), (118, 9);
insert into tbl_e1 values (11, 1), (12, 2), (13, 2), (14, 4);
insert into tbl_e2 values (115, 5), (116, 6), (117, 6), (118, 9);

update statistics on tbl_a, tbl_b, tbl_c, tbl_d, tbl_e, tbl_e1, tbl_e2 with fullscan;


evaluate 'Case 1: the reported queries -- GROUP BY on tbl_a alone, and the same with a one-row cross join';
--@queryplan
select /*+ recompile */ a.colb, count(*) as cnt from tbl_a a group by a.colb using index a.idx_colb;
--@queryplan
select /*+ recompile */ a.colb, count(*) as cnt from tbl_a a, tbl_c c group by a.colb using index a.idx_colb;


evaluate 'Case 2: an inner join under a cross join, the index of tbl_a is two joins down';
--@queryplan
select /*+ recompile ordered use_idx */ a.colb, count(*) as cnt
  from tbl_a a, tbl_b b, tbl_c c
 where b.cold = a.cola
 group by a.colb
 using index a.idx_colb, b.idx_cold;


evaluate 'Case 3: left outer join, a tbl_a row without a match in tbl_b is counted in its group';
--@queryplan
select /*+ recompile use_idx */ a.colb, count(*) as cnt, count(b.colc) as cnt_b
  from tbl_a a left outer join tbl_b b on b.cold = a.cola
 group by a.colb
 using index a.idx_colb, b.idx_cold;


evaluate 'Case 4: hash join, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered use_hash */ a.colb, count(*) as cnt
  from tbl_a a, tbl_b b
 where b.cold = a.cola
 group by a.colb
 using index a.idx_colb, b.idx_cold;


evaluate 'Case 5: right outer join, the GROUP BY is still sorted and the tbl_b row without a match makes the NULL group';
--@queryplan
select /*+ recompile */ a.colb, count(*) as cnt
  from tbl_a a right outer join tbl_b b on b.cold = a.cola
 group by a.colb
 using index a.idx_colb;


evaluate 'Case 6: partitioned table as the inner, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered use_idx */ a.colb, count(*) as cnt
  from tbl_a a, tbl_d d
 where d.colg = a.cola
 group by a.colb
 using index a.idx_colb;


evaluate 'Case 7: class hierarchy as the inner, the GROUP BY is still sorted';
--@queryplan
select /*+ recompile ordered */ a.colb, count(*) as cnt
  from tbl_a a, all tbl_e e
 where e.coli = a.cola
 group by a.colb
 using index a.idx_colb;


evaluate 'Case 8: ROWNUM in the WHERE clause rules the skip out, the index scan is not a candidate and the GROUP BY is sorted as before';
--@queryplan
select /*+ recompile ordered */ a.colb, count(*) as cnt
  from tbl_a a, tbl_c c
 where rownum <= 3
 group by a.colb;
--@queryplan
select /*+ recompile ordered */ a.colb, count(*) as cnt
  from tbl_a a, tbl_c c
 where rownum <= 3
 group by a.colb
 using index a.idx_colb;


drop table tbl_a, tbl_b, tbl_c, tbl_d;
drop table tbl_e1, tbl_e2;
drop table tbl_e;
