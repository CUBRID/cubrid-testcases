/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_1: cost.sql 
 *  1. build input: small tuple count
 *  2. build input: small tuple count + ordered
 *  3. build input: int vs bigint  -> int or bigint (page: int == bigint)
 *  4. build input: int vs numeric -> int (page: int < numeric)
 *  5. cost: in_memory, hybrid < file, build_method: in_memory
 *  6. cost: in_memory, hybrid < file, build_method: hybrid
 *  7. cost: in_memory, hybrid < file, build_method: file
 */

set @i = 0;

drop table if exists ta, tb, tc, td, t_bigint, t_numeric;
create table ta (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table tb (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table tc (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table td (ca int, cb int, cc int, cd int, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table t_bigint (ca bigint, cb bigint, cc bigint, cd bigint, index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));
create table t_numeric (ca numeric (10, 0), cb numeric (10, 0), cc numeric (10, 0), cd numeric (10, 0), index i_a (ca, cb, cc), index i_b (cb, cc), index i_c (cd));

insert into ta
  with recursive cte (n) as (
      select 1
      union all
      select n + 1 from cte where n < 2000
    )
  select mod (n, 10), mod (n, 100), mod (n, 1000), n from cte;
insert into tb select * from ta;
insert into tc select * from ta;
insert into td select * from ta;
insert into t_bigint select * from ta;
insert into t_numeric select * from ta;

update statistics on ta, tb, tc, td, t_bigint, t_numeric with fullscan;

set trace on;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. build input: small tuple count');

--@queryplan
select /*+ recompile use_hash */
  count (*)
from ta a, tb b, tc c, td d
where a.cd = b.cd and b.cd = c.cd and c.cd = d.cd
  and a.cb in (1, 2)       /* expected results: 40 */
  and b.cb in (1, 2, 3)    /* expected results: 60 */
  and c.cb in (1, 2, 3, 4) /* expected results: 80 */
  and d.cb in (1)          /* expected results: 20 */
  ;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. build input: small tuple count + ordered');

--@queryplan
select /*+ recompile ordered use_hash */
  count (*)
from ta a, tb b, tc c, td d
where a.cd = b.cd and b.cd = c.cd and c.cd = d.cd
  and a.cb in (1, 2, 3)    /* expected results: 60 */
  and b.cb in (1, 2, 3, 4) /* expected results: 80 */
  and c.cb in (1)          /* expected results: 40 */
  and d.cb in (1, 2)       /* expected results: 20 */
  ;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. build input: int vs bigint -> int or bigint (page: int == bigint)');

--@queryplan
select /*+ recompile use_hash */
  count (*)
from ta a, t_bigint b
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. build input: int vs numeric -> int (page: int < numeric)');

--@queryplan
select /*+ recompile use_hash */
  count (*)
from ta a, t_numeric b
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. cost: in_memory, hybrid < file, build_method: in_memory');

set system parameters 'max_hash_list_scan_size=512k';

--@queryplan
select /*+  recompile use_hash(a,b) use_nl(c) */
  count (*)
from ta a, tb b, tc c
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd
  and a.ca = c.ca and a.cb = c.cb and a.cc = c.cc and a.cd = c.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. cost: in_memory, hybrid < file, build_method: hybrid');

set system parameters 'max_hash_list_scan_size=128k';

--@queryplan
select /*+  recompile use_hash(a,b) use_nl(c) */
  count (*)
from ta a, tb b, tc c
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd
  and a.ca = c.ca and a.cb = c.cb and a.cc = c.cc and a.cd = c.cd;

show trace;
--select trace_stats ();

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. cost: in_memory, hybrid < file, build_method: file');

set system parameters 'max_hash_list_scan_size=64k';

--@queryplan
select /*+  recompile ordered use_hash(a,b) use_nl(c) */
  count (*)
from ta a, tb b, tc c
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd
  and a.ca = c.ca and a.cb = c.cb and a.cc = c.cc and a.cd = c.cd;

show trace;
--select trace_stats ();

--@queryplan
select /*+  recompile use_hash(a,b) use_nl(c) */
  count (*)
from ta a, tb b, tc c
where a.ca = b.ca and a.cb = b.cb and a.cc = b.cc and a.cd = b.cd
  and a.ca = c.ca and a.cb = c.cb and a.cc = c.cc and a.cd = c.cd;

show trace;
--select trace_stats ();

set system parameters 'max_hash_list_scan_size=default';

set trace off;

drop table ta, tb, tc, td, t_bigint, t_numeric;
drop variable @i;

