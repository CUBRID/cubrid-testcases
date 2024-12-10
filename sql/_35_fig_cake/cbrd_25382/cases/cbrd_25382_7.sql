/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_7: view_merging.sql 
 *  1. hint: recompile use_hash
 *  2. hint: recompile                                    + use_hash
 *  3. hint: recompile use_hash                           + use_hash
 *  4. hint: recompile                 no_use_hash        + use_hash
 *  5. hint: recompile use_hash(ab,c)                     + use_hash(a,b)
 *  6. hint: recompile use_hash(ab)                       +                 no_use_hash(a)
 *  7. hint: recompile                 no_use_hash(ab)    + use_hash(a)
 *  8. hint: recompile                 no_use_hash(a,b,c) + use_hash(a,b,c)
 *  9. hint: recompile use_hash(a,b,c)                    +                 no_use_hash(a,b,c)
 */

set @i = 0;

drop table if exists ta, tb, tc;
create table ta (ca int, flag int);
insert into ta values (1, 1), (2, 1), (3, 1), (4, 1);
create table tb as select a.ca, a.flag from ta a;
create table tc as select a.ca, a.flag from ta a;

-- unnecessary
update statistics on ta, tb, tc with fullscan;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash');

--@queryplan
select /*+ recompile use_hash */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile + use_hash');

--@queryplan
select /*+ recompile */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash + use_hash');

--@queryplan
select /*+ recompile use_hash */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile no_use_hash + use_hash');

--@queryplan
select /*+ recompile no_use_hash */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(ab,c) + use_hash(a,b)');

--@queryplan
select /*+ recompile use_hash(ab,c) */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash(a,b) */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(ab) + no_use_hash(a)');

--@queryplan
select /*+ recompile use_hash(ab) */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ no_use_hash(a) */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile no_use_hash(ab) + use_hash(a)');

--@queryplan
select /*+ recompile no_use_hash(ab) */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash(a) */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile no_use_hash(a,b,c) + use_hash(a,b,c)');

--@queryplan
select /*+ recompile no_use_hash(a,b,c) */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ use_hash(a,b,c) */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(a,b,c) + no_use_hash(a,b,c)');

--@queryplan
select /*+ recompile use_hash(a,b,c) */
  ab.a_ca as a_ca, ab.b_ca as b_ca, c.ca as c_ca
from
  (
    select /*+ no_use_hash(a,b,c) */
      a.ca as a_ca, b.ca as b_ca
    from ta a, tb b
    where a.ca = b.ca and a.flag = 1 and b.flag = 1
  ) ab,
  tc c
where ab.b_ca = c.ca and c.flag = 1;

drop table ta, tb, tc;
drop variable @i;

