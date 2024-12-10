/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_4: select_hint.sql 
 *  1. hint: recompile ordered use_hash
 *  2. hint: recompile ordered use_hash(a)
 *  3. hint: recompile ordered use_hash(b)
 *  4. hint: recompile ordered use_hash(c)
 *  5. hint: recompile ordered use_hash(d)
 *  6. hint: recompile ordered use_hash        no_use_hash
 *  7. hint: recompile ordered use_hash        no_use_hash(a)
 *  8. hint: recompile ordered use_hash        no_use_hash(b)
 *  9. hint: recompile ordered use_hash        no_use_hash(c)
 * 10. hint: recompile ordered use_hash        no_use_hash(d)
 * 11. hint: recompile ordered use_hash(a,b)   no_use_hash(c,d)
 * 12. hint: recompile ordered use_hash(a,c)   no_use_hash(b,d)
 * 13. hint: recompile ordered use_hash(a,b,c) no_use_hash(b,d)
 * 14. hint: recompile ordered use_hash(b,c,d) no_use_hash(b,c,d)
 */

set @i = 0;

drop table if exists ta, tb, tc, td;
create table ta (ca int);
insert into ta (ca) values (1), (2), (3), (4);
create table tb as select a.ca from ta a;
create table tc as select a.ca from ta a;
create table td as select a.ca from ta a;

-- unnecessary
update statistics on ta, tb, tc, td with fullscan;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash');

--@queryplan
select /*+ recompile ordered use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a)');

--@queryplan
select /*+ recompile ordered use_hash(a) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b)');

--@queryplan
select /*+ recompile ordered use_hash(b) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(c)');

--@queryplan
select /*+ recompile ordered use_hash(c) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(d)');

--@queryplan
select /*+ recompile ordered use_hash(d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash');

--@queryplan
select /*+ recompile ordered use_hash no_use_hash */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(a)');

--@queryplan
select /*+ recompile ordered use_hash no_use_hash(a) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(b)');

--@queryplan
select /*+ recompile ordered use_hash no_use_hash(b) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(c)');

--@queryplan
select /*+ recompile ordered use_hash no_use_hash(c) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(d)');

--@queryplan
select /*+ recompile ordered use_hash no_use_hash(d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b) no_use_hash(c,d)');

--@queryplan
select /*+ recompile ordered use_hash(a,b) no_use_hash(c,d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,c) no_use_hash(b,d)');

--@queryplan
select /*+ recompile ordered use_hash(a,c) no_use_hash(b,d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b,c) no_use_hash(b,d)');

--@queryplan
select /*+ recompile ordered use_hash(a,b,c) no_use_hash(b,d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b,c,d) no_use_hash(b,c,d)');

--@queryplan
select /*+ recompile ordered use_hash(b,c,d) no_use_hash(b,c,d) */
  a.ca as a_ca, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca
order by a.ca;

drop table ta, tb, tc, td;
drop variable @i;

