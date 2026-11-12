/*
 * CBRD-27461: aggregates, GROUP BY, analytic functions and ORDER BY ... LIMIT of a
 * hierarchical (CONNECT BY) query must be evaluated on the hierarchy expansion,
 * not on the rows read by the scan.
 *
 * Five optimizations trusted the scan row count or the index order:
 *  1. count-only index scan: when the START WITH column is indexed, the index scan
 *     counted the START WITH keys (1) instead of feeding the hierarchy -> 1 row.
 *  2. statistics/index based COUNT(*)/MIN/MAX: without START WITH the WHERE clause is
 *     moved to the after-CONNECT-BY filter, so the query looks like "no WHERE" and the
 *     class count (unique index) or the index MIN/MAX was returned.
 *  3. GROUP BY skip: one group was split into several rows.
 *  4. analytic sort skip / limit: partitions were split and ROW_NUMBER/RANK followed
 *     the expansion order.
 *  5. multi-range optimization: only the top N START WITH rows were kept.
 *
 * Schema: tree_t(c1 pk, c2) chain 1->2->3->4->5 plus an unrelated row (10,9).
 *   expansion without START WITH = 4+3+2+1+1 = 11 rows
 *   expansion START WITH c2=1     = 4 rows
 */

evaluate '[SETUP]';
drop table if exists tree_t;
drop table if exists tree_j;
drop table if exists tree_big;
drop table if exists tree_m;

create table tree_t (c1 int primary key, c2 int);
insert into tree_t values (2,1),(3,2),(4,3),(5,4),(10,9);
create index idx_tree_t_c2 on tree_t (c2);

create table tree_j (k int, v int);
insert into tree_j values (1,100),(2,200),(3,300),(4,400),(9,900);
create index idx_tree_j_k on tree_j (k);

-- 100-row chain, START WITH column indexed (count-only path on a longer hierarchy)
create table tree_big (c1 int primary key, c2 int);
insert into tree_big
  select rownum, rownum - 1 from db_root connect by level <= 100;
create index idx_tree_big_c2 on tree_big (c2);

-- roots a = 1, the child (50,2,1) of the root (1,1,100) has the smallest b
create table tree_m (c1 int primary key, a int, b int);
insert into tree_m values (1,1,100),(50,2,1),(10,1,2),(11,1,3),(12,1,4),(13,1,5);
create index idx_tree_m_abc on tree_m (a, b, c1);
update statistics on tree_m with fullscan;

evaluate '[1] reference: expanded rows';
select c1, c2, level from tree_t start with c2 = 1 connect by c2 = prior c1 order by 1, 3;
select c1, c2, level from tree_t connect by c2 = prior c1 order by 1, 3;
select c1, c2, level from tree_t start with c2 > 0 connect by c2 = prior c1 order by 2, 1, 3;
select c1, a, b, level from tree_m start with a in (1) connect by b = prior c1 order by b, c1;

evaluate '[2] count-only index scan on the START WITH column (was 1)';
select count(*) from tree_t start with c2 = 1 connect by c2 = prior c1;
select count(*) from tree_t start with c2 = 1 connect by c2 = prior c1 and level <= 3;
select count(*) from tree_t where level > 1 start with c2 = 1 connect by c2 = prior c1;
select count(c1) from tree_t start with c2 = 1 connect by c2 = prior c1;
select count(*) from tree_big start with c2 = 0 connect by c2 = prior c1;
select count(*) from tree_big start with c2 = 90 connect by c2 = prior c1;
select (select count(*) from tree_t start with c2 = 1 connect by c2 = prior c1) as cnt from db_root;

evaluate '[3] statistics based COUNT(*) without START WITH (was the class row count 5)';
select count(*) from tree_t connect by c2 = prior c1;
select count(*) from tree_t where c1 > 0 connect by c2 = prior c1;
select count(*) from tree_t where level > 1 connect by c2 = prior c1;
select count(*) from tree_t where level = 1 connect by c2 = prior c1;
select count(c1) from tree_t connect by c2 = prior c1;
select count(*) from tree_big connect by c2 = prior c1;

evaluate '[4] index based MIN/MAX with an after-CONNECT-BY filter (was 10 / 2)';
select max(c1) from tree_t where c1 < 5 connect by c2 = prior c1;
select min(c1) from tree_t where c1 > 2 connect by c2 = prior c1;
select min(c1), max(c1) from tree_t where c1 > 2 connect by c2 = prior c1;
select min(c1), max(c1), count(*) from tree_t where level > 2 connect by c2 = prior c1;

evaluate '[5] other aggregate shapes stay correct';
select count(c2) from tree_t start with c2 = 1 connect by c2 = prior c1;
select sum(1) from tree_t start with c2 = 1 connect by c2 = prior c1;
select count(*), max(level) from tree_t start with c2 = 1 connect by c2 = prior c1;
select count(*) from (select c1 from tree_t start with c2 = 1 connect by c2 = prior c1) x;
select count(*) from tree_t a, tree_j b where a.c2 = b.k start with a.c2 = 1 connect by a.c2 = prior a.c1;
select count(*) from tree_t a, tree_j b where a.c2 = b.k connect by a.c2 = prior a.c1;

evaluate '[6] non hierarchical optimizations are unaffected';
select count(*) from tree_t;
select count(*) from tree_t where c2 = 1;
select min(c1), max(c1) from tree_t;
select count(*) from tree_big where c2 >= 50;
select c2, count(*) from tree_t where c2 > 0 group by c2 order by 1;
select c2, count(*) over (partition by c2) from tree_t where c2 > 0 order by 1, 2;
select a, b, c1 from tree_m where a in (1, 2) order by b, c1 limit 3;

evaluate '[7] GROUP BY in the START WITH index order (was split groups)';
select c2, count(*) from tree_t start with c2 > 0 connect by c2 = prior c1 group by c2 order by 1;
select c1, count(*) from tree_t start with c1 > 0 connect by c2 = prior c1 group by c1 order by 1;

evaluate '[8] analytic functions in the START WITH index order (was split partitions)';
select c2, count(*) over (partition by c2) from tree_t start with c2 > 0 connect by c2 = prior c1 order by 1, 2;
select c2, sum(c1) over (partition by c2) from tree_t start with c2 > 0 connect by c2 = prior c1 order by 1, 2;
select c2, row_number() over (order by c2) rn from tree_t start with c2 > 0 connect by c2 = prior c1 order by rn;
select c2, rank() over (order by c2) rk from tree_t start with c2 > 0 connect by c2 = prior c1 order by 1, 2;
select c2, row_number() over (order by c2) rn from tree_t start with c2 > 0 connect by c2 = prior c1 order by rn limit 3;

evaluate '[9] ORDER BY ... LIMIT in the START WITH index order (was the top N roots only)';
select a, b, c1 from tree_m start with a in (1) connect by b = prior c1 order by b, c1 limit 3;
select a, b, c1 from tree_m start with a in (1) connect by b = prior c1 order by b, c1 for orderby_num() <= 3;

evaluate '[10] sequential scan after dropping the START WITH index';
drop index idx_tree_t_c2 on tree_t;
select count(*) from tree_t start with c2 = 1 connect by c2 = prior c1;
select count(*) from tree_t connect by c2 = prior c1;

evaluate '[CLEANUP]';
drop table if exists tree_t;
drop table if exists tree_j;
drop table if exists tree_big;
drop table if exists tree_m;
