/**
 *  This test case verifies CBRD-25382: Support HASH JOIN with hint required
 *  cbrd_25382_6: update_hint.sql 
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
create table ta (ca int, flag int);
insert into ta (ca) values (1), (2), (3), (4), (5), (6), (7), (8);
create table tb as select a.ca, a.flag from ta a;
create table tc as select a.ca, a.flag from ta a;
create table td as select a.ca, a.flag from ta a;

-- unnecessary
update statistics on ta, tb, tc, td with fullscan;

prepare check_result from '
select
  a.ca as a_ca, a.flag as a_flag, b.flag as b_flag, c.flag as c_flag, d.flag as d_flag
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
update /*+ recompile ordered use_hash */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a)');

update ta a set a.flag = 1 where a.ca in (1);

--@queryplan
update /*+ recompile ordered use_hash(a) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b)');

update ta a set a.flag = 1 where a.ca in (2);

--@queryplan
update /*+ recompile ordered use_hash(b) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(c)');

update ta a set a.flag = 1 where a.ca in (3);

--@queryplan
update /*+ recompile ordered use_hash(c) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(d)');

update ta a set a.flag = 1 where a.ca in (4);

--@queryplan
update /*+ recompile ordered use_hash(d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 5, 6, 7, 8);

--@queryplan
update /*+ recompile ordered use_hash no_use_hash */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(a)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 5);

--@queryplan
update /*+ recompile ordered use_hash no_use_hash(a) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(b)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 6);

--@queryplan
update /*+ recompile ordered use_hash no_use_hash(b) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(c)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 7);

--@queryplan
update /*+ recompile ordered use_hash no_use_hash(c) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash no_use_hash(d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 4, 8);

--@queryplan
update /*+ recompile ordered use_hash no_use_hash(d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b) no_use_hash(c,d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 7, 8);

--@queryplan
update /*+ recompile ordered use_hash(a,b) no_use_hash(c,d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,c) no_use_hash(b,d)');

update ta a set a.flag = 1 where a.ca in (1, 3, 6, 8);

--@queryplan
update /*+ recompile ordered use_hash(a,c) no_use_hash(b,d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(a,b,c) no_use_hash(b,d)');

update ta a set a.flag = 1 where a.ca in (1, 2, 3, 6, 8);

--@queryplan
update /*+ recompile ordered use_hash(a,b,c) no_use_hash(b,d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

do @i := @i + 1;
evaluate concat ('####', lpad (@i, 3), '. hint: recompile ordered use_hash(b,c,d) no_use_hash(b,c,d)');

update ta a set a.flag = 1 where a.ca in (2, 3, 4, 6, 7, 8);

--@queryplan
update /*+ recompile ordered use_hash(b,c,d) no_use_hash(b,c,d) */
  ta a, tb b, tc c, td d
set b.flag = 1, c.flag = 1, d.flag = 1
where a.ca = b.ca and b.ca = c.ca and c.ca = d.ca and a.flag = 1;

execute check_result;
rollback;

autocommit on;

deallocate prepare check_result;
drop table ta, tb, tc, td;
drop variable @i;

