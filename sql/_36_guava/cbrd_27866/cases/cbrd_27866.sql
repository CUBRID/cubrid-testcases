-- CBRD-27866: a partitioned table as a nested-loop inner is walked per outer row
-- instead of running the outer again for every partition. A join term on the partition
-- key picks the partition of each outer row.
--
-- The outer filter o.a + (@c := @c + 1) > 0 counts how many times the outer rows are read.
-- Before the fix the scan block iterator ran the outer once per inner partition, so @c was
-- the outer row count times the partition count. Now @c is the outer row count, the same as
-- for an unpartitioned inner, and the results do not change. An outer join or a class
-- hierarchy after the inner keeps the scan block iteration.

drop table if exists t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hc, t_hp, t_pk, t_ob, t_pi;

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

update statistics on t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hp, t_hc, t_pk, t_ob, t_pi with fullscan;

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

-- Case 9: an outer join and a class hierarchy keep the scan block iteration, the results are the same
select /*+ ordered no_use_hash parallel(0) */ count (*), count (r.v), sum (r.v)
from t_o o left join t_pr r on r.k = o.a;

select /*+ ordered no_use_hash parallel(0) */ count (*), sum (h.v)
from t_s s inner join t_p w on w.k = s.k inner join all t_hp h on h.k = w.k - 1;

select /*+ ordered no_use_hash parallel(0) */ count (*), sum (w.id)
from all t_hp h inner join t_p w on w.k = h.k;

-- Case 10: row limit and group by over the join
select /*+ ordered no_use_hash parallel(0) */ count (*)
from (select o.a, w.id from t_o o inner join t_p w on w.k = o.k where rownum <= 17) t;

select /*+ ordered no_use_hash parallel(0) */ w.k, count (*)
from t_o o inner join t_p w on w.k = o.k group by w.k order by w.k;

-- Case 11: parallel outer
select /*+ ordered no_use_hash parallel(2) */ count (*), sum (w.id)
from t_o o inner join t_p w on w.k = o.k;

-- Case 12: FOR UPDATE, UPDATE and DELETE through a partitioned inner
select /*+ ordered no_use_hash parallel(0) */ u.k
from t_s s, t_u u where u.k between s.k and s.k + 2 order by 1 for update;

update /*+ ordered no_use_hash */ t_o o inner join t_u u on u.k = o.a set u.s = u.s + o.k where o.a < 30;
select count (*), sum (s) from t_u;

delete /*+ ordered no_use_hash */ u from t_o o inner join t_u u on u.k = o.a where o.k = 1;
select count (*), sum (s) from t_u;

drop table t_o, t_x, t_p, t_np, t_pr, t_pl, t_po, t_s, t_u, t_hc, t_hp, t_pk, t_ob, t_pi;
drop variable @c;
