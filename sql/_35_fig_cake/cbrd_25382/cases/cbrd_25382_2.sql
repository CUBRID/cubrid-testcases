/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_2: delete_hint.sql 
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
 * 15. hint: recompile         use_hash
 * 16. hint: recompile         use_hash(a,b,c)                    -> split(d)
 * 17. hint: recompile                         no_use_hash
 * 18. hint: recompile                         no_use_hash(a,b)   -> split(c,d)
 * 19. hint: recompile         use_hash(a,c)   no_use_hash(b)     -> split(d)
 * 20. hint: recompile         use_hash(a,b)
 * 21. hint: recompile         use_hash(a,b,c)
 */

set @i = 0;

drop table if exists ta, tb, tc, td;
create table ta (ca int, flag int);
insert into ta (ca) values (1), (2), (3), (4), (5), (6), (7), (8);
create table tb as select a.ca from ta a;
create table tc as select a.ca from ta a;
create table td as select a.ca from ta a;

-- unnecessary
update statistics on ta, tb, tc, td with fullscan;

prepare check_result from '
select
  a.ca as a_ca, a.flag as a_flag, b.ca as b_ca, c.ca as c_ca, d.ca as d_ca
from
  ta a
  left outer join tb b on b.ca = a.ca
  left outer join tc c on c.ca = a.ca
  left outer join td d on d.ca = a.ca
';

autocommit off;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4);

--@queryplan
delete /*+ recompile ordered use_hash */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a)');

update ta a set a.flag = 1 where a.ca in (1);

--@queryplan
delete /*+ recompile ordered use_hash(a) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b)');

update ta a set a.flag = 1 where a.ca in (2);

--@queryplan
delete /*+ recompile ordered use_hash(b) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(c)');

update ta a set a.flag = 1 where a.ca in (3);

--@queryplan
delete /*+ recompile ordered use_hash(c) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(d)');

update ta a set a.flag = 1 where a.ca in (4);

--@queryplan
delete /*+ recompile ordered use_hash(d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 5, 6, 7, 8);

--@queryplan
delete /*+ recompile ordered use_hash no_use_hash */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(a)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 5);

--@queryplan
delete /*+ recompile ordered use_hash no_use_hash(a) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(b)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 6);

--@queryplan
delete /*+ recompile ordered use_hash no_use_hash(b) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(c)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 7);

--@queryplan
delete /*+ recompile ordered use_hash no_use_hash(c) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 8);

--@queryplan
delete /*+ recompile ordered use_hash no_use_hash(d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b) no_use_hash(c,d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 7, 8);

--@queryplan
delete /*+ recompile ordered use_hash(a,b) no_use_hash(c,d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,c) no_use_hash(b,d)');

update ta a set a.flag = 1 where a.ca in (1, 3, 6, 8);

--@queryplan
delete /*+ recompile ordered use_hash(a,c) no_use_hash(b,d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b,c) no_use_hash(b,d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 6, 8);

--@queryplan
delete /*+ recompile ordered use_hash(a,b,c) no_use_hash(b,d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b,c,d) no_use_hash(b,c,d)');

update ta a set a.flag = 1 where a.ca in (2, 3, 4, 6, 7, 8);

--@queryplan
delete /*+ recompile ordered use_hash(b,c,d) no_use_hash(b,c,d) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4);

--@queryplan
delete /*+ recompile use_hash */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca /* and c.ca = d.ca */ and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(a,b,c) -> split(d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3);

--@queryplan
delete /*+ recompile use_hash(a,b,c) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca /* and c.ca = d.ca */ and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile no_use_hash');

update ta a set a.flag = 1 where a.ca in (5, 6, 7, 8);

--@queryplan
delete /*+ recompile no_use_hash */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca /* and b.ca = c.ca and c.ca = d.ca */ and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile no_use_hash(a,b) -> split(c,d)');

update ta a set a.flag = 1 where a.ca in (5, 6);

--@queryplan
delete /*+ recompile no_use_hash(a,b) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca /* and b.ca = c.ca and c.ca = d.ca */ and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(a,c) no_use_hash(b) -> split(d)');

update ta a set a.flag = 1 where a.ca in (1, 3, 6);

--@queryplan
delete /*+ recompile use_hash(a,c) no_use_hash(b) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca /* and b.ca = c.ca and c.ca = d.ca */ and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(a,b)');

update ta a set a.flag = 1 where a.ca in (1, 2);

--@queryplan
delete /*+ recompile use_hash(a,b) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca /* and b.ca = c.ca */ and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile use_hash(a,b,c)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3);

--@queryplan
delete /*+ recompile use_hash(a,b,c) */
  b, c, d
from ta a, tb b, tc c, td d
where a.ca = b.ca and b.ca = c.ca /* and c.ca = d.ca */ and a.flag = 1 and d.ca = 8;

execute check_result;
rollback;

autocommit on;

deallocate prepare check_result;
drop table if exists ta, tb, tc, td;
drop variable @i;

