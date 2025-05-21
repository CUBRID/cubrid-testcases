/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_3: outer_join.sql
 *  1. left outer join (ansi)
 *  2. left outer join (non-ansi)
 *  3. left outer join + during join terms
 *  4. left outer join (ansi) + after join terms
 *  5. left outer join (non-ansi) + after join terms
 *  6. right outer join (ansi)
 *  7. right outer join (non-ansi)
 *  8. right outer join + during join terms
 *  9. right outer join (ansi) + after join terms
 * 10. right outer join (non-ansi) + after join terms
 */

set @i = 0;

drop table if exists ta, tb, tc, td;
create table ta (ca int, flag int);
insert into ta values (1, 0), (2, 0), (3, 0), (4, 0);
insert into ta values (1, 1), (2, 1), (3, 1), (4, 1);
create table tb as select a.ca, a.flag from ta a where a.ca != 2;
create table tc as select a.ca, a.flag from ta a where a.ca != 3;
create table td as select a.ca, a.flag from ta a where a.ca != 4;

--unnecessary
update statistics on ta, tb, tc, td with fullscan;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. left outer join (ansi)', ' ####');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a
  left outer join tb b on b.ca = a.ca and b.flag = 1 /* sarg term */
  left outer join tc c on c.ca = b.ca and c.flag = 1 /* sarg term */
  left outer join td d on d.ca = c.ca and d.flag = 1 /* sarg term */
where
  a.flag = 1 /* sarg term */
order by
  a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. left outer join (non-ansi)');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a, tb b, tc c, td d
where
  a.flag = 1 /* sarg term */
  and a.ca = b.ca(+) and b.flag(+) = 1 /* sarg term */
  and b.ca = c.ca(+) and c.flag(+) = 1 /* sarg term */
  and c.ca = d.ca(+) and d.flag(+) = 1 /* sarg term */
order by
  a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. left outer join + during join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a
  left outer join tb b on b.ca = a.ca and b.flag = 1 /* sarg term */ and a.flag = 1 /* during join term */
  left outer join tc c on c.ca = b.ca and c.flag = 1 /* sarg term */ and b.flag = 1 /* during join term */
  left outer join td d on d.ca = c.ca and d.flag = 1 /* sarg term */ and c.flag = 1 /* during join term */
where
  a.flag = 1 /* sarg term */
order by
  a.flag, a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. left outer join (ansi) + after join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a
  left outer join tb b on b.ca = a.ca
  left outer join tc c on c.ca = b.ca
  left outer join td d on d.ca = c.ca
where
  a.flag = 1 /* sarg term */
  and nvl (b.flag, 0) = 0 /* after join term */
  and nvl (c.flag, 0) = 0 /* after join term */
  and nvl (d.flag, 0) = 0 /* after join term */
order by
  a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. left outer join (non-ansi) + after join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a, tb b, tc c, td d
where
  a.flag = 1 /* sarg term */
  and a.ca = b.ca(+) and nvl (b.flag, 0) = 0 /* after join term */
  and b.ca = c.ca(+) and nvl (c.flag, 0) = 0 /* after join term */
  and c.ca = d.ca(+) and nvl (d.flag, 0) = 0 /* after join term */
order by
  a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. right outer join (ansi)');

--@queryplan
select /*+ recompile ordered use_hash */
  d.ca as d_ca, d.flag as d_flag,
  c.ca as c_ca, c.flag as c_flag,
  b.ca as b_ca, b.flag as b_flag,
  a.ca as a_ca
from
  td d
  right outer join tc c on c.ca = d.ca
  right outer join tb b on b.ca = c.ca
  right outer join ta a on a.ca = b.ca
where
  a.flag = 1 /* sarg term */
order by
  a.ca, b.flag, b.ca, c.flag, c.ca, d.flag, d.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. right outer join (non-ansi)');

--@queryplan
select /*+ recompile ordered use_hash */
  d.ca as d_ca, d.flag as d_flag,
  c.ca as c_ca, c.flag as c_flag,
  b.ca as b_ca, b.flag as b_flag,
  a.ca as a_ca
from
  td d, tc c, tb b, ta a
where
  a.flag = 1 /* sarg term */
  and d.ca(+) = c.ca
  and c.ca(+) = b.ca
  and b.ca(+) = a.ca
order by
  a.ca, b.flag, b.ca, c.flag, c.ca, d.flag, d.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. right outer join + during join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  d.ca as d_ca, d.flag as d_flag,
  c.ca as c_ca, c.flag as c_flag,
  b.ca as b_ca, b.flag as b_flag,
  a.ca as a_ca, a.flag as a_flag
from
  td d
  right outer join tc c on c.ca = d.ca and c.flag = 1 /* during join term */
  right outer join tb b on b.ca = c.ca and b.flag = 1 /* during join term */
  right outer join ta a on a.ca = b.ca and a.flag = 1 /* during join term */
order by
  a.flag, a.ca, b.flag, b.ca, c.flag, c.ca, d.flag, d.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. right outer join (ansi) + after join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  d.ca as d_ca, c.ca as c_ca, b.ca as b_ca, a.ca as a_ca
from
  td d
  right outer join tc c on c.ca = d.ca
  right outer join tb b on b.ca = c.ca
  right outer join ta a on a.ca = b.ca
where
  a.flag = 1 /* sarg term */
  and nvl (d.flag, 0) = 0 /* after join term */
  and nvl (c.flag, 0) = 0 /* after join term */
  and nvl (b.flag, 0) = 0 /* after join term */
order by
  a.ca, b.ca, c.ca, d.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. right outer join (non-ansi) + after join terms');

--@queryplan
select /*+ recompile ordered use_hash */
  d.ca as d_ca, c.ca as c_ca, b.ca as b_ca, a.ca as a_ca
from
  td d, tc c, tb b, ta a
where
  a.flag = 1 /* sarg term */
  and d.ca(+) = c.ca and nvl (d.flag, 0) = 0 /* after join term */
  and c.ca(+) = b.ca and nvl (c.flag, 0) = 0 /* after join term */
  and b.ca(+) = a.ca and nvl (b.flag, 0) = 0 /* after join term */
order by
  a.ca, b.ca, c.ca, d.ca;

drop table ta, tb, tc, td;
drop variable @i;

