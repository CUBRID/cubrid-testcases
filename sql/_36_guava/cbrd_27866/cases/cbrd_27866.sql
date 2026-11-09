-- CBRD-27866: a partitioned table as a nested-loop inner is walked per outer row
-- instead of running the outer again for every partition. A join term on the partition
-- key picks the partition of each outer row.
--
-- The outer filter o.a + (@c := @c + 1) > 0 counts how many times the outer rows are read.
-- Before the fix the scan block iterator ran the outer once per inner partition, so @c was
-- the outer row count times the partition count. Now @c is the outer row count, the same as
-- for an unpartitioned inner, and the results do not change. Only a class hierarchy
-- keeps the scan block iteration.

drop table if exists t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hc, t_hp, t_pk, t_ob, t_pi, t_rn, t_uv;

create table t_o (a int primary key, k int);
insert into t_o select rownum, mod (rownum, 6) from db_class a, db_class b limit 60;

create table t_x (k int primary key, v int);
insert into t_x select rownum, rownum * 10 from db_class a, db_class b limit 60;

create table t_p (k int, id int, primary key (k, id)) partition by hash (k) partitions 8;
insert into t_p values (0, 1), (1, 10), (1, 11), (2, 20), (2, 21), (3, 30), (3, 31), (4, 40), (5, 50);

create table t_np (k int, id int, primary key (k, id));
insert into t_np select * from t_p;

create table t_pr (k int primary key, v int) partition by range (k)
  (partition p0 values less than (20), partition p1 values less than (40), partition p2 values less than maxvalue);
insert into t_pr select rownum * 2, rownum from db_class a, db_class b limit 40;

create table t_pl (k int, v int, primary key (k, v)) partition by list (k)
  (partition l0 values in (0, 1, 2), partition l1 values in (3, 4), partition l2 values in (5, 6));
insert into t_pl select mod (rownum, 7), rownum from db_class a, db_class b limit 70;

create table t_po (a int primary key, k int) partition by hash (a) partitions 4;
insert into t_po select * from t_o;

create table t_pk (k int primary key, v int) partition by hash (k) partitions 8;
insert into t_pk select rownum, rownum * 3 from db_class a, db_class b limit 60;

create table t_pi (k int, id int, primary key (k, id)) partition by hash (id) partitions 8;
insert into t_pi select * from t_p;

create table t_rn (k int primary key, v int) partition by range (k)
  (partition r0 values less than (20), partition r1 values less than (40));
insert into t_rn select rownum * 2, rownum from db_class a, db_class b limit 19;

create table t_uv (k int, id int, s int, primary key (k, id)) partition by hash (id) partitions 4;
insert into t_uv select mod (rownum, 6), rownum, 0 from db_class a, db_class b limit 24;

create table t_ob (a int primary key, kb bigint);
insert into t_ob select a, a from t_o;

create table t_s (k int primary key);
insert into t_s values (2);

create table t_u (k int primary key, s int) partition by hash (k) partitions 4;
insert into t_u select rownum, 0 from db_class a, db_class b limit 60;

create table t_hp (k int, v int);
create table t_hc under t_hp;
insert into t_hp values (1, 1), (2, 2), (3, 3);
insert into t_hc values (1, 10), (4, 40);

update statistics on t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hp, t_hc, t_pk, t_ob, t_pi, t_rn, t_uv with fullscan;

-- Case 1: keys repeat. The outer is read 60 times as with the unpartitioned inner.
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_p w on w.k = o.k where o.a + (@c := @c + 1) > 0;
select @c;

set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_np w on w.k = o.k where o.a + (@c := @c + 1) > 0;
select @c;

-- Case 2: the joined rows in order
select /*+ ordered no_use_hash parallel(0) */ o.a, w.k, w.id
from t_o o inner join t_p w on w.k = o.k where o.a <= 8 order by o.a, w.id;

-- Case 3: NL chain t_o, t_x, then the partitioned inner
set @c = 0;
select /*+ ordered no_use_hash no_merge parallel(0) */ count (*), sum (x.v), sum (w.id)
from t_o o inner join t_x x on x.k = o.a inner join t_p w on w.k = mod (x.k, 6)
where o.a + (@c := @c + 1) > 0;
select @c;

-- Case 3b: a unique outer key joined on the partition key prunes the inner to one partition per row
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (p.v)
from t_o o inner join t_pk p on p.k = o.a where o.a + (@c := @c + 1) > 0;
select @c;

select /*+ ordered no_use_hash parallel(0) */ o.a, p.v
from t_o o inner join t_pk p on p.k = o.a where o.a between 10 and 14 order by o.a;

-- the outer column has another type: no pruning by the join value, the same rows
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (p.v)
from t_ob o inner join t_pk p on p.k = o.kb;

-- Case 3c: the key repeats on a column that is not the partition key. Walked per row with the memo,
-- and also when an expression of the inner keeps the memo off
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_pi w on w.k = o.k where o.a + (@c := @c + 1) > 0;
select @c;

set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_pi w on w.k = o.k and w.id + length (sys_guid ()) > 0 where o.a + (@c := @c + 1) > 0;
select @c;

-- Case 4: range and list partitioned inners
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (r.v)
from t_o o inner join t_pr r on r.k = o.a where o.a + (@c := @c + 1) > 0;
select @c;

set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (l.v)
from t_o o inner join t_pl l on l.k = o.k where o.a + (@c := @c + 1) > 0;
select @c;

-- Case 5: two partitioned inners in a row
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id), sum (l.v)
from t_o o inner join t_p w on w.k = o.k inner join t_pl l on l.k = w.k
where o.a + (@c := @c + 1) > 0;
select @c;

-- Case 6: partitioned outer and partitioned inner
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_po o inner join t_p w on w.k = o.k;

-- Case 7: the partitioned inner after an anti join, and a semi join after the partitioned inner
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o anti join t_s s on s.k = o.k inner join t_p w on w.k = o.k;

select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_p w on w.k = o.k
where exists (select 1 from t_pl l where l.k = w.k and l.v > 60);

-- Case 8: a constant prunes the inner to one partition
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from t_o o inner join t_p w on w.k = o.k and w.k = 3;

-- Case 9: outer joins walk the partitions per outer row and return the NULL row once
-- on the partition key, most outer keys fall in no range partition
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), count (r.v), sum (r.v)
from t_o o left join t_rn r on r.k = o.a where o.a + (@c := @c + 1) > 0;
select @c;

select /*+ ordered no_use_hash parallel(0) */ o.a, r.v
from t_o o left join t_rn r on r.k = o.a where o.a between 36 and 42 order by o.a;

-- not on the partition key
set @c = 0;
select /*+ ordered no_use_hash parallel(0) */ count (*), count (w.id), sum (w.id)
from t_o o left join t_pi w on w.k = o.k + 3 where o.a + (@c := @c + 1) > 0;
select @c;

-- after a partitioned inner join, and written as a right join
select /*+ ordered no_use_hash parallel(0) */ count (*), count (r.v), sum (r.v)
from t_o o inner join t_p w on w.k = o.k left join t_rn r on r.k = w.id;

select /*+ ordered no_use_hash parallel(0) */ count (*), count (r.v), sum (r.v)
from t_rn r right join t_o o on r.k = o.a;

-- Case 10: semi and anti joins prune per outer row, an anti join with no partition left lets the row through
select /*+ ordered no_use_hash parallel(0) */ count (*)
from t_o o where not exists (select 1 from t_rn r where r.k = o.a);

select /*+ ordered no_use_hash parallel(0) */ count (*)
from t_o o where exists (select 1 from t_rn r where r.k = o.a);

-- Case 11: locking scans through a partitioned inner joined on a column that is not the partition key
select /*+ ordered no_use_hash parallel(0) */ o.a, w.id
from t_o o, t_uv w where w.k = o.k and o.a between 1 and 3 order by 1, 2 for update;

update /*+ ordered no_use_hash */ t_o o inner join t_uv w on w.k = o.k set w.s = w.s + o.a where o.a <= 12;
select count (*), sum (s) from t_uv;

-- Case 12: a class hierarchy keeps the scan block iteration, the results are the same
select /*+ ordered no_use_hash parallel(0) */ count (*), sum (h.v)
from t_s s inner join t_p w on w.k = s.k inner join all t_hp h on h.k = w.k - 1;

select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from all t_hp h inner join t_p w on w.k = h.k;

-- Case 13: row limit and group by over the join
select /*+ ordered no_use_hash parallel(0) */ count (*)
from (select o.a, w.id from t_o o inner join t_p w on w.k = o.k where rownum <= 17) t;

select /*+ ordered no_use_hash parallel(0) */ w.k, count (*)
from t_o o inner join t_p w on w.k = o.k group by w.k order by w.k;

-- Case 14: parallel outer
select /*+ ordered no_use_hash parallel(2) */ count (*), sum (w.id)
from t_o o inner join t_p w on w.k = o.k;

-- Case 15: FOR UPDATE, UPDATE and DELETE through a partitioned inner
select /*+ ordered no_use_hash parallel(0) */ u.k
from t_s s, t_u u where u.k between s.k and s.k + 2 order by 1 for update;

update /*+ ordered no_use_hash */ t_o o inner join t_u u on u.k = o.a set u.s = u.s + o.k where o.a < 30;
select count (*), sum (s) from t_u;

delete /*+ ordered no_use_hash */ u from t_o o inner join t_u u on u.k = o.a where o.k = 1;
select count (*), sum (s) from t_u;

-- Case 16 (CBRD-27928): ORDER BY is skipped because the outer index returns the rows in order.
-- The scan block iteration returned them in partition order instead. Walked per outer row,
-- the order of the outer index is kept, with and without pruning, ascending and descending.
select /*+ ordered no_use_hash parallel(0) */ o.a, p.v
from t_o o inner join t_pk p on p.k = o.a where o.a between 10 and 14 order by o.a desc;

select /*+ ordered no_use_hash parallel(0) */ o.a, w.id
from t_o o inner join t_p w on w.k = o.k where o.a between 10 and 14 order by o.a;

select /*+ ordered no_use_hash parallel(0) */ o.a, w.id
from t_o o inner join t_p w on w.k = o.k where o.a between 10 and 14 order by o.a desc;

-- Case 17: a subquery run again opens its partitioned inner again. The last outer row it pruned
-- (k = 7) left out every partition, and the next run starts from all of them again.
create table t_o2 (k int);
insert into t_o2 values (3), (1), (2), (5), (7);
create table t_rp (k int, a int) partition by range (k)
  (partition p0 values less than (1), partition p1 values less than (2), partition p2 values less than (3),
   partition p3 values less than (4), partition p4 values less than (5), partition p5 values less than (6),
   partition p6 values less than (7), partition p7 values less than (8));
create index i_rp_k on t_rp (k);
insert into t_rp values (1, 1), (3, 3), (2, 2), (4, 4);
update statistics on t_o2, t_rp with fullscan;

select o.a, (select /*+ ordered use_nl */ count (*) from t_o2 o2, t_rp r
             where r.k = o2.k and r.k in (1, 3) and o.a > 0) cnt
from t_o o where o.a <= 5 order by 1;

-- an anti join whose outer row leaves no partition (k = 2, 5, 7): one partition is opened and the row passes
select /*+ ordered use_nl */ count (*) from t_o2 o2
where not exists (select 1 from t_rp r where r.k = o2.k and r.k in (1, 3));

-- Case 18: an outer join on a term that prunes no partition, the inner read from a temp list or per outer row
select count (*), count (w.id), sum (w.id)
from t_o o left join t_p w on w.k between o.k and o.k + 1;

select count (*), count (w.id), sum (w.id)
from t_o o left join t_p w on w.k between o.k and o.k + 1 and w.id > 20;

drop table t_o2, t_rp;

-- Case 19: a term of the inner compares the partition key with an expression of an inner column. Pruned per
-- outer row, the column still holds the value read for the previous outer row; it must not prune.
create table t_ja (id int, k int);
create table t_jb (k int, c int) partition by range (k)
  (partition p0 values less than (10), partition p1 values less than (20), partition p2 values less than maxvalue);
insert into t_ja values (1, 25), (2, 15);
insert into t_jb values (25, 0), (15, 100);

select /*+ recompile ordered use_nl(b) */ a.id, b.k, b.c from t_ja a, t_jb b
where b.k = a.k and b.k <= b.c + 1 order by 1;

select /*+ recompile ordered use_nl(b) */ a.id, b.k, b.c from t_ja a left join t_jb b
on b.k = a.k and b.k <= b.c + 1 order by 1;

select /*+ recompile */ a.id from t_ja a
where not exists (select 1 from t_jb b where b.k = a.k and b.k <= b.c + 1) order by 1;

drop table t_ja, t_jb;

-- Case 20: a partition expression of the key. A join term prunes once the outer value is set, not before
create table t_fe (k int, v int) partition by hash (k * 2 + 1) partitions 4;
insert into t_fe values (0, 10), (1, 11), (2, 12), (3, 13), (5, 15);
create table t_fo (id int, i int);
insert into t_fo values (1, 0), (2, 1), (3, 2), (4, 3), (5, 5), (6, 9);

select o.id, t.k, t.v from t_fo o left join t_fe t on t.k = o.i order by 1;
select o.id, t.k, t.v from t_fo o right join t_fe t on t.k = o.i order by 2;
select o.id, t.k, t.v from t_fo o, t_fe t where t.k = o.i order by 1;

drop table t_fe, t_fo;

-- Case 21: the range terms of an index scan carry the conjuncts after them, and one compares the partition key with a
-- column of the scan after the partitioned inner. That value is not read yet for the outer row: it must not prune.
create table t_co (id int, a int, b int);
insert into t_co values (1, 5, 2), (2, 6, 0), (3, 5, 9), (4, 7, -1);
create table t_cp (k int, c int, v int) partition by hash (k) partitions 4;
create index i_cp_kc on t_cp (k, c);
insert into t_cp select mod(rownum, 4) + 5, mod(rownum, 12), rownum from db_class a, db_class b limit 96;
create table t_cy (k int, v int);
create index i_cy_k on t_cy (k);
insert into t_cy values (5, 50), (6, 60), (7, 70), (5, 51);

select /*+ ordered use_nl */ count (*), sum (x.v), sum (y.v) from t_co o, t_cp x, t_cy y
where x.k = o.a and x.c > o.b and x.c >= 0 and y.k = x.k using index x.i_cp_kc;

select /*+ ordered use_nl */ o.id, count (*) from t_co o, t_cp x use index (i_cp_kc), t_cy y
where x.k = o.a and x.c > o.b and x.c between 0 and 10 and y.k = x.k group by o.id order by 1;

drop table t_co, t_cp, t_cy;

drop table t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hc, t_hp, t_pk, t_ob, t_pi, t_rn, t_uv;
drop variable @c;
